#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "geometry.h"

#define MAX_LINE 256 
#define IFS ','

int check_point ( struct point_c a, int line_no, char *line );

int main () {
    char l[MAX_LINE];
    struct point_c a, b;
    int i;

    fgets( l, MAX_LINE, stdin );
    if( l == NULL || strlen(l) == 0 ) {
        fprintf( stderr, "Problem reading from stdin. Did you cat an empty file?\n" );
        exit(1);
    }

    a = l_to_c(l, IFS);
    check_point( a, 1, l );

    i = 2;
    while
    ( fgets( l, MAX_LINE, stdin ) != NULL )
    {
        b = l_to_c(l, IFS);
        check_point( b, i, l );

        printf( "%f\n", distance(a,b) );
        a = b;
        i++;
    }

    return 0;
}

int check_point
(
    struct point_c a,
    int line_no,
    char *line
)
{
    if ( ! a.ok ) {
        fprintf( stderr, "Problem creating point from line %d: %s", line_no, line );
        exit(1);
    }
    return 0;
}
