#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "geometry.h"

#define MAX_LINE 256
#define FS ','

/* this program takes 3 lines from stdin

   it prints the difference between the x values
   from lines 1 and 3 to stdout

   and prints the the y value of line 2 to fd3

   expected invocation:

       this_program \
     < driver/X/trip/Y/morphology-points \
     > driver/X/trip/Y/width \
    3> driver/X/trip/Y/max_distance_from_origin
*/

struct point_c next_point ();

int main ()
{
    struct point_c left_most, furthest, right_most;
    double width, max_distance_from_origin;

    left_most  = next_point();
    furthest   = next_point();
    right_most = next_point();

    width = right_most.x - left_most.x;
    max_distance_from_origin = furthest.y;

    printf( "%f\n", width );
    dprintf( 3, "%f\n", max_distance_from_origin );
}

struct point_c c;
char l[MAX_LINE];

struct point_c next_point ()
{
    fgets( l, MAX_LINE, stdin );
    if ( l == NULL || strlen(l) == 0 ) {
        fprintf( stderr, "Problem reading from stdin. fgets errno (%d)", errno );
        exit(1);
    }

    c = l_to_c( l, FS );
    check_point_c( c, 1, l );

    return c;
}
