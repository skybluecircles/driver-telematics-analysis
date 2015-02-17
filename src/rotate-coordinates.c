#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "geometry.h"

#define MAX_LINE 256
#define MAX_DURATION 65536
#define IFS ','

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

    c = l_to_c( l, IFS );
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
        c = l_to_c( l, IFS );
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
