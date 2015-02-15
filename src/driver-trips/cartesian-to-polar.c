#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define MAX_ARGS 32767
#define MAX_ARG_LENGTH 8
#define MAX_PATH_LENGTH 256
#define MAX_LINE_LENGTH 256
#define IFS ","

int main( int argc, char *argv[] ) {
    int  i;

    char in[MAX_PATH_LENGTH];
    char out[MAX_PATH_LENGTH];

    FILE *ifp;
    FILE *ofp;

    char line[MAX_LINE_LENGTH];

    float x;
    float y;

    float radius;
    float azimuth;

    char driver_id[MAX_ARG_LENGTH];
    int trip_id;

    int  path_length;
    char ENV_VAR[MAX_LINE_LENGTH];
    char DTA_DATA[MAX_LINE_LENGTH];

    snprintf( ENV_VAR, MAX_LINE_LENGTH, "%s", "DTA_DATA" );
    path_length = strlen(getenv(ENV_VAR));

    if ( path_length > MAX_PATH_LENGTH ) {
        fprintf(
            stderr,
            "You have too many characters (%d) in the enviroment variable DTA_DATA. The limit is (%d).",
            path_length, MAX_PATH_LENGTH
        );
        exit(1);
    }
    else {
        snprintf( DTA_DATA, MAX_PATH_LENGTH, "%s", getenv(ENV_VAR) );
    }

    if ( argc < 2 ) {
        fprintf( stderr, "Usage: %s 1 [2 [ n ] ]\n", argv[0] );
        exit(1);
    }
    else if ( argc > MAX_ARGS ) {
        fprintf( stderr, "Too many arguments (%d). Limit is (%d)\n", argc, MAX_ARGS );
        exit(1);
    }

    for ( i = 1; i < argc; i++ ) {
        if ( strlen(argv[i]) > MAX_ARG_LENGTH ) {
            fprintf( stderr, "arg %d (%s) has more than %d characters\n", i, argv[i], MAX_ARG_LENGTH );
            exit(1);
        }
    }

    for ( i = 1; i < argc; i++ ) {
        snprintf( driver_id, MAX_ARG_LENGTH, "%s", argv[i] );

        for ( trip_id = 1; trip_id <= 200; trip_id++ ) {
            snprintf(
              in, MAX_PATH_LENGTH,
              "%s/driver/%s/trip/%d/coordinates-cartesian",
              DTA_DATA, driver_id, trip_id
            );

            snprintf(
              out, MAX_PATH_LENGTH,
              "../data/driver/%s/trip/%d/coordinates-polar-c2",
              driver_id, trip_id
            );

            ifp = fopen( in, "r" );
            ofp = fopen( out, "w" );

            if ( ifp == NULL ) {
                fprintf( stderr, "Can't open %s\n", in );
                exit(1);
            }

            if ( ofp == NULL ) {
                fprintf( stderr, "Can't open %s\n", out );
                exit(1);
            }

            while ( fgets( line, MAX_LINE_LENGTH, ifp ) != NULL ) {
                line[ strcspn( line, "\n") ] = 0;

                x = atof( strtok( line, IFS ) );
                y = atof( strtok( NULL, IFS ) );

                radius = sqrt(pow(x,2)+pow(y,2));
                azimuth = atan2(y,x);

                fprintf( ofp, "%f,%f\n", radius, azimuth );
            }

            fclose(ifp);
            fclose(ofp);
        }
    }
}
