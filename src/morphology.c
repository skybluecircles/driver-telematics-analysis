#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "geometry.h"

#define MAX_LINE 256
#define FS ','

int main() {
    char l[MAX_LINE];
    struct point_c c, furthest_from_origin, left_most, right_most;
    int i;

    fgets( l, MAX_LINE, stdin );
    if ( l == NULL || strlen(l) == 0 ) {
        fprintf( stderr, "Problem reading from stdin. Did you cat an emptry or non existant file?" );
        exit(1);
    }

    c = l_to_c( l, FS );
    check_point_c( c, 1, l );

    left_most = right_most = furthest_from_origin = c;

    while
    ( fgets( l, MAX_LINE, stdin ) != NULL )
    {
        c = l_to_c( l, FS );
        check_point_c( c, i, l );

        if ( c.x < left_most.x )
            left_most = c;

        if ( c.x > right_most.x )
            right_most = c;

        if ( c.y > furthest_from_origin.y )
            furthest_from_origin = c;
    }

    print_point_c( left_most, FS );
    print_point_c( furthest_from_origin, FS );
    print_point_c( right_most, FS );
}
