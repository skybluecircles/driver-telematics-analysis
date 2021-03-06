#include <stdio.h>
#include <stdlib.h>
#include "geometry.h"
#include "io.h"

#define MAX_LINE 256
#define IFS ','

/* We're calculating how much the driver turns
   as they move from point to point */

int points_c_are_identical
(
    struct point_c a,
    struct point_c b
);

int main()
{
    struct point_c prev_pos, current_pos;
    int line_no;

    line_no = 1;
    if ( fget_point_c( &prev_pos, stdin, line_no ) == 0 )
    {
        fprintf( stderr, "Problem reading from stdin. Did you cat an empty file?\n" );
        exit(1);
    }
    ++line_no;

    while ( fget_point_c( &current_pos, stdin, line_no ) != 0 ) {
        if ( points_c_are_identical( current_pos, prev_pos ) ) {
            continue;
        }
        else {
            printf( "%f\n", interval_rotation( current_pos, prev_pos ) );
            prev_pos = current_pos;
        }
        ++line_no;
    }

    return 0;
}

int points_c_are_identical
(
    struct point_c a,
    struct point_c b
)
{
    if ( a.x == b.x && a.y == b.y ) {
        return 1;
    }
    else {
        return 0;
    }
}
