#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#include <errno.h>

#define MAX_LINE 256
#define MAX_DURATION 65536 
#define IFS ","

struct point_c {
    double x;
    double y;
    int   ok;
};

struct point_p {
    double radius;
    double azimuth;
    int    ok;
};

struct point_c l_to_c ( char * line );
struct point_p c_to_p ( struct point_c c );
struct point_p rotate ( struct point_p p, double rotation );
struct point_c p_to_c ( struct point_p p );
double calculate_rotation ( struct point_p hb ); 

int main ()
{
    char l[MAX_LINE];

    struct point_c c;
    struct point_p p;
    struct point_p hb; /* homebody */
    struct point_p polars[MAX_DURATION];

    double rotation;

    int l_no = 1;
    int i;

    fgets( l, MAX_LINE, stdin );
    if( l == NULL || strlen(l) == 0 ) {
        fprintf( stderr, "Problem reading from stdin. Did you cat an empty file?\n" );
        exit(1);
    }

    c = l_to_c(l);
    if( !c.ok ) {
        fprintf( stderr, "Problem reading line 1 from stdin\n" );
        exit(1);
    }
        
    p = c_to_p(c);

    hb = p;
    polars[0] = p;

    while
    ( fgets ( l, MAX_LINE, stdin ) != NULL )
    {
        c = l_to_c(l);
        if( !c.ok ) {
            fprintf( stderr, "Problem reading line %d from stdin\n", l_no + 1 );
            exit(1);
        }

        p = c_to_p(c);

        if ( p.radius > hb.radius )
            hb = p; 

        polars[l_no] = p;
        l_no++;
    }
    l_no--; /* will be using it again */

    rotation = calculate_rotation(hb);

    for ( i = 0; i <= l_no; i++ )
    {
        p = rotate( polars[i], rotation );
        c = p_to_c(p);

        printf( "%f,%f\n", c.x, c.y );
    }
}

struct point_c l_to_c
(
    char * l
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
    if( errno == ERANGE || endptr == l || *endptr != ',' ) {
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
