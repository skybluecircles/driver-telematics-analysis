use strict;
use warnings;

use Test::More;
use Test::Fatal;
use DTA::WebApp::Helper qw(next_driver prev_driver);

VALID: {

    my @tests = (
        {
            driver => 1,
            next   => 2,
            prev   => 3612.
        },
        {
            driver => 3612,
            next   => 1,
            prev   => 3611,
        },
        {
            driver => 162,
            next   => 163,
            prev   => 161,
        },
        {
            driver => 3,
            next   => 10,
            prev   => 2,
        },
        {
            driver => 100,
            next   => 101,
            prev   => 36,
        },
    );

    foreach my $test (@tests) {
        my $driver = $test->{driver};

        my $next = next_driver($driver);
        is( $next, $test->{next}, sprintf( 'Next for driver (%d)', $driver ) );

        my $prev = prev_driver($driver);
        is( $prev, $test->{prev}, sprintf( 'Prev for driver (%d)', $driver ) );
    }
}

INVALID: {

    my @non_existant_drivers = qw( 5 700 5000 );

    foreach my $driver (@non_existant_drivers) {
        like(
            exception { next_driver($driver) },
            qr/^No index for driver/,
            'Next for non-existant driver raises exception'
        );

        like(
            exception { prev_driver($driver) },
            qr/^No index for driver/,
            'Prev for non-existant driver raises exception'
        );
    }
}

done_testing();
