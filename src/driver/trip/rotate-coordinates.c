#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>

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

int is_valid_token( char *l ); 
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
    char *token;

    l[ strcspn( l, "\n") ] = 0;

    c.ok = 1;
    token = strtok( l, IFS );
    if( token != NULL && is_valid_token(token) ) {
        c.x = atof( token );
    }
    else {
        c.ok = 0;
    }

    token = strtok( NULL, IFS );
    if( token != NULL && is_valid_token(token) ) {
        c.y = atof( token );
    }
    else {
        c.ok = 0;
    }

    return c;
}

int is_valid_token( char *l ) {
    int len;
    int i;
    char c;
    int cnt = 0;

    len = strlen(l); 
    if ( len == 0 ) {
        return 0;
    }

    for( i = 0; i < len; i++ ) {
        c = l[i];
        if( isdigit(c) ) {
            continue;
        }
        else if( i == 0 && c == '-' ) {
            continue;
        }
        else if( c == '.' && cnt < 1 ) {
            cnt++;
            continue;
        }
        else {
            return 0;
        }
    }

    return 1;
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
