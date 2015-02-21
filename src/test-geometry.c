#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "geometry.h"

#define TEST_COUNT 2
#define ASSERTION "Distance between points is within tolerance"
#define TOLERANCE 0.00001

struct point_c points[TEST_COUNT] = { {1,1}, {4,5} };
double actual[TEST_COUNT];
double expected[TEST_COUNT] = { 1.41421356237, 5.00000000 };

int main() {
    int i, j;
    struct point_c prev, current;

    prev.x = prev.y = 0;
    for ( i = 0; i < TEST_COUNT; i++ ) {
        current = points[i];
        actual[i] = distance( prev, current );
        prev = current;
    }

    /* should pass points and expected to another function
       for comparison */

    int errors = 0;
    for ( j = 0; j < TEST_COUNT; j++ ) {
        if( fabs( actual[j] - expected[j] ) > TOLERANCE ) {
            fprintf( stderr, "Test %d - NOT ok: %s\n", j + 1, ASSERTION );
            errors++;
        }
        else {
            printf( "Test %d - IS ok: %s\n", j + 1, ASSERTION );
        }
   }
}
