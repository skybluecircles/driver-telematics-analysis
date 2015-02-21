#include <stdio.h>
#include <stdlib.h>
#include <math.h>     /* sin cos M_PI */
#include <errno.h>
#include "geometry.h"

struct point_c l_to_c
(
    char *l,
    char ifs
)
{
    struct point_c c;
    char *endptr;

    /* I'm expecting to receive a line like "1.34227,9.21210\n"
       or "1.34227,921210EOF"

       The first call to strtod should return 1.34227 and set
       endptr to the ",".

       I then increment endptr by 1 to point to the 9 in 9.21210.

       So, the second call to strtod should return 9.21210 and
       set endptr to whatever comes after it, if anything.

       Note that in the first call, when I check for endptr == l,
       I'm checking whether endptr actually moved as I don't want
       a line like ",5423.12185" to be considered valid. */

    c.ok = 1;
    c.x = strtod( l, &endptr );

    if( errno == ERANGE ) {
        fprintf( stderr, "Warning: overflow or underflow when converting line to point\n" );
    }
    if( errno == ERANGE || endptr == l || *endptr != ifs ) {
        c.ok = 0;
        return c;
    }

    endptr++;
    c.y = strtod( endptr, &endptr );

    if( errno == ERANGE ) {
        fprintf( stderr, "Warning: overflow or underflow when converting line to point\n" );
    }
    else if( *endptr != '\0' && *endptr != '\n' && *endptr != EOF ) {
        c.ok = 0;
    }

    return c;
}

struct point_p c_to_p
(
    struct point_c c
)
{
    struct point_p p;

    p.radius = sqrt(pow(c.x,2)+pow(c.y,2));
    p.azimuth = atan2(c.y,c.x);

    return p;
}

double calculate_rotation
(
    struct point_p hb
)
{
    double angle = hb.azimuth;

    /* quadrant 1 or 2 */
    if ( angle > 0 ) {
        return M_PI_2 - angle;
    }

    /* quadrant 3 */
    if ( angle < M_PI_2 * -1 ) {
        return ( M_PI_2 * -3 ) - angle;
    }

    /* quadrant 4 */
    return M_PI_2 - angle;
}

struct point_p rotate
(
    struct point_p p,
    double rotation
)
{
    p.azimuth += rotation;

    if ( p.azimuth < M_PI * -1 ) {
        p.azimuth += M_PI * 2;
    }
    else if ( p.azimuth > M_PI ) {
        p.azimuth -= M_PI * 2;
    }

    return p;
}

struct point_c p_to_c
(
    struct point_p p
)
{
    struct point_c c;

    c.x = p.radius * cos( p.azimuth );
    c.y = p.radius * sin( p.azimuth );

    return c;
}

double distance
(
    struct point_c a,
    struct point_c b
)
{
    /* the distance between two points a,b */

    return sqrt(pow((a.x-b.x),2)+pow((a.y-b.y),2));
}
