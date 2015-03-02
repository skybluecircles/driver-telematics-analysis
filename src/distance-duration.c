#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define MAX_LINE 256

int fgetd
(
    double *d,
    FILE *fh
)
;

char *fgets_s
(
    char *line,
    int size,
    FILE *fh
);

double strtod_s
(
    char *nptr,
    char *endptr
);


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
    
int fgetd
(
    double *d,
    FILE *fh
)
{
    char line[MAX_LINE];
    char *endptr;

    if( fgets_s( line, MAX_LINE, fh ) == NULL )
        return 0;

    *d = strtod_s( line, endptr );

    return 1;
}

char *fgets_s
(
    char *line,
    int size,
    FILE *fh
)
{
    char *rv;

    rv = fgets( line, MAX_LINE, fh );

    if( rv == NULL && ( errno != 0 | ferror(fh) != 0 ) ) {
        fprintf( stderr, "Problem reading from fh\n" );
        exit(1);
    }

    return rv;
}

double strtod_s
(
    char *nptr,
    char *endptr
)
{
    double d;

    d = strtod( nptr, &endptr );

    if( errno == ERANGE ) {
        fprintf( stderr, "Warning: overflow or underflow when converting line to point\n" );
    }
    if ( errno == ERANGE || endptr == nptr || ( *endptr != '\0' && *endptr != '\n' && *endptr != EOF ) ) {
        fprintf( stderr, "Error converting line (%s) to double\n", nptr );
        exit(1);
    }

    return d;
}
