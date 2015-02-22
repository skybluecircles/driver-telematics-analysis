#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#define MAX_LINE 32
#define EOL '\n'

double safe_strtod ( char *l, char end_char );

int main() {
    char l[MAX_LINE];
    double a, b;

    fgets( l, MAX_LINE, stdin );
    if ( l == NULL ) {
        fprintf( stderr, "Problem reading from stdin. Did you cat an empty or non-existant file?\n" );
        exit(1);
    }
    a = safe_strtod( l, EOL );

    while( fgets( l, MAX_LINE, stdin ) != NULL ) {
        b = safe_strtod( l, EOL );
        printf( "%f\n", b - a );
        a = b;
    }
}

double safe_strtod ( char *l, char end_char ) {
    double d;
    char *endptr;

    d = strtod( l, &endptr );

    if ( errno == ERANGE ) {
        fprintf( stderr, "Overflow or underflow when converting line (%s) to double\n", l );
        exit(1);
    }
    else if ( endptr == l || *endptr != end_char ) {
        fprintf( stderr, "Problem converting line (%s) to double\n", l );
        exit(1);
    }
    else {
        return d;
    }
}
