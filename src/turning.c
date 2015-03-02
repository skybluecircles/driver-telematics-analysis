#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "geometry.h"
#include "io.h"

#define MAX_LINE 256
#define IFS ','

/* We're calculating how much the driver turns
   as they move from point to point */

int fget_point_c
(
    struct point_c * pt,
    FILE *fh,
    int line_no
);

struct point_c subtract_points_c
(
    struct point_c a,
    struct point_c b
);

double relative_angle
(
    struct point_c a,
    struct point_c b
);

int main()
{
    struct point_c prev_pos, current_pos;
    double prev_angle, current_angle;
    int line_no;

    line_no = 1;
    if ( fget_point_c( &prev_pos, stdin, line_no ) == 0 )
    {
        fprintf( stderr, "Problem reading from stdin. Did you cat an empty file?\n" );
        exit(1);
    }
    ++line_no;

    if ( fget_point_c( &current_pos, stdin, line_no ) == 0 )
    {
        fprintf( stderr, "Need at least 3 points to be able to calculate the amount of turning\n" );
        exit(1);
    }
    ++line_no;

    prev_angle = relative_angle( current_pos, prev_pos ); 
    prev_pos   = current_pos;

    while ( fget_point_c( &current_pos, stdin, line_no ) != 0 )
    {
        current_angle = relative_angle( current_pos, prev_pos );
        printf( "%f\n", current_angle - prev_angle );

        prev_pos = current_pos;
        prev_angle = current_angle;
        ++line_no;
    }

    return 0;
}

double relative_angle
(
    struct point_c a,
    struct point_c b
)
{
    struct point_c transp;

    transp = subtract_points_c( a, b );

    return atan2( transp.y, transp.x );
}

struct point_c subtract_points_c
(
    struct point_c a,
    struct point_c b
)
{
    struct point_c diff;

    diff.x = a.x - b.x;
    diff.y = a.y - b.y;

    return diff;
}

int fget_point_c
(
    struct point_c * pt,
    FILE *fh,
    int line_no
)
{
    char line[MAX_LINE];
    char *endptr;

    if( fgets_s( line, MAX_LINE, fh ) == NULL )
        return 0;

    *pt = l_to_c( line, IFS );

    if( ! pt->ok ) {
        fprintf( stderr, "Problem converting line %d to point: %s\n", line_no, line );
        exit(1);
    }

    return 1;
}
