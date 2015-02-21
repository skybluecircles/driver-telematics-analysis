#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "geometry.h"

#define MAX_LINE 256 
#define IFS ','

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
    if( !a.ok ) {
        fprintf( stderr, "Problem creating point from line 1 from stdin (%s)\n", l );
        exit(1);
    }

    i = 2;
    while
    ( fgets( l, MAX_LINE, stdin ) != NULL )
    {
        b = l_to_c(l, IFS);
        if ( !b.ok ) {
            fprintf( stderr,"Problem creating point from line %d (%s)\n", i, l );
            exit(1);
        }

        printf( "%f\n", distance(a,b) );
        a = b;
        i++;
    }
}
