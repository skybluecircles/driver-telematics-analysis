#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define MAX_LINE 256

int next_double( double *d );

int main ()
{
    double prev;
    double current;

    if ( next_double(&prev) == 0 ) {
        fprintf( stderr, "Problem reading first line of stdin. Did you cat an empty file?\n" );
        exit(1);
    }

    while( next_double(&current) != 0 )
    {
        printf( "%f\n", current - prev );
        prev = current;
    }
}


int next_double
(
    double *d
)
{
    char l[MAX_LINE];
    char *rv;
    char *endptr;

    rv = fgets( l, MAX_LINE, stdin );

    if( rv == NULL ) { /* need to distinguish between eof and error */
        if ( errno != 0 || ferror(stdin) != 0 ) {
            fprintf( stderr, "Problem reading from stdin\n" );
            exit(1);
        }
        else {
            return 0;
        }
    }

    *d = strtod( l, &endptr );

    if( errno == ERANGE ) {
        fprintf( stderr, "Warning: overflow or underflow when converting line to point\n" );
    }
    if ( errno == ERANGE || endptr == l || ( *endptr != '\0' && *endptr != '\n' && *endptr != EOF ) ) {
        fprintf( stderr, "Error converting line (%s) to double\n", l );
        exit(1);
    }

    return 1;
}
