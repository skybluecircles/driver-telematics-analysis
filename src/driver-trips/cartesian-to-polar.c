#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define MAX_ARG_LEN 32
#define MAX_PATH_LEN 1024
#define MAX_LINE_LEN 256
#define IFS ","

int check_args( int argc, char *argv[] );
int setup_environment( char *DTA_DATA );

FILE * open_ifp( int driver_id, int trip_id );
FILE * open_ofp( int driver_id, int trip_id );

struct cartesian line_to_cartesian( char * line );
struct polar cartesian_to_polar( struct cartesian c );

struct cartesian {
    float x;
    float y;
};

struct polar {
    float radius;
    float azimuth;
};

char DTA_DATA[MAX_PATH_LEN];

int main( int argc, char *argv[] ) {
    extern char DTA_DATA[];

    int driver_id;
    int trip_id;

    FILE *ifp;
    FILE *ofp;

    char line[MAX_LINE_LEN];

    struct cartesian c;
    struct polar p;

    setup_environment( DTA_DATA );
    check_args( argc, argv );

    driver_id = atoi( argv[1] );

    for( trip_id = 1; trip_id <= 200; trip_id++ ) {
        ifp = open_ifp( driver_id, trip_id );
        ofp = open_ofp( driver_id, trip_id );

        while ( fgets( line, MAX_LINE_LEN, ifp ) != NULL ) {
            c = line_to_cartesian(line);
            p = cartesian_to_polar(c);

            fprintf( ofp, "%f,%f\n", p.radius, p.azimuth );
        }

        fclose(ifp);
        fclose(ofp);
    }
}

int check_args( int argc, char *argv[] ) {
    if ( argc != 2 ) {
        fprintf( stderr, "Usage: %s driver_id\n", argv[0] );
        exit(1);
    }
    return 0;
}

int setup_environment( char *DTA_DATA ) {
    snprintf( DTA_DATA, MAX_PATH_LEN, "%s", getenv("DTA_DATA") );
    return 0;
}

FILE * open_ifp( int driver_id, int trip_id ) {
    char in[MAX_PATH_LEN];
    FILE *ifp;

    snprintf(
      in, MAX_PATH_LEN,
      "%s/driver/%d/trip/%d/coordinates-cartesian",
      DTA_DATA, driver_id, trip_id
    );

    ifp = fopen( in, "r" );

    if ( ifp == NULL ) {
        fprintf( stderr, "Can't open %s\n", in );
        exit(1);
    }

    return ifp;
}

FILE * open_ofp( int driver_id, int trip_id ) {
    char out[MAX_PATH_LEN];
    FILE *ofp;

    snprintf(
      out, MAX_PATH_LEN,
      "%s/driver/%d/trip/%d/coordinates-polar",
      DTA_DATA, driver_id, trip_id
    );

    ofp = fopen( out, "w" );

    if ( ofp == NULL ) {
        fprintf( stderr, "Can't open %s\n", out );
        exit(1);
    }

    return ofp;
}

struct cartesian line_to_cartesian( char * line ) {
    struct cartesian c;

    line[ strcspn( line, "\n") ] = 0;

    c.x = atof( strtok( line, IFS ) );
    c.y = atof( strtok( NULL, IFS ) );

    return c;
}

struct polar cartesian_to_polar( struct cartesian c ) {
    struct polar p;

    p.radius = sqrt(pow(c.x,2)+pow(c.y,2));
    p.azimuth = atan2(c.y,c.x);

    return p;
}
