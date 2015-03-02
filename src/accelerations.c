#include <stdio.h>
#include <stdlib.h>
#include "io.h"

int main ()
{
    double prev, current;

    if ( fgetd( &prev, stdin ) == 0 )
    {
        fprintf( stderr, "Problem reading first line of stdin. Did you cat an empty file?\n" );
        exit(1);
    }

    while( fgetd( &current, stdin ) != 0 )
    {
        printf( "%f\n", current - prev );
        prev = current;
    }

    return 0;
}
