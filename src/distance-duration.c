#include <stdio.h>
#include <stdlib.h>
#include "io.h"

int main ()
{
    double sum;
    double dist;
    int i;

    sum = i = 0;

    while( fgetd( &dist, stdin ) != 0 ) {
        sum += dist;
        ++i;
    }

    printf( "%f\n", sum );
    dprintf( 3, "%d\n", i );

    return 0;
}
