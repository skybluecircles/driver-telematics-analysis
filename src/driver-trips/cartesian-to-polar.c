#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define PATHMAX 256 
#define LINEMAX 256
#define IFS ","

int main() {
    char in[PATHMAX];
    char out[PATHMAX];

    FILE *ifp;
    FILE *ofp;

    char line[LINEMAX];

    float x;
    float y;

    float radius;
    float azimuth;

    int driver_id = 1;
    int trip_id;

    for ( trip_id = 1; trip_id <= 200; trip_id++ ) {
        snprintf(
          in, PATHMAX,
          "../data/driver/%d/trip/%d/coordinates-cartesian",
          driver_id, trip_id
        );

        snprintf(
          out, PATHMAX,
          "../data/driver/%d/trip/%d/coordinates-polar",
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

        while ( fgets( line, LINEMAX, ifp ) != NULL ) {
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
