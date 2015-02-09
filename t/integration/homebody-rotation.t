#!/usr/bin/perl

use strict;
use warnings;

use lib './lib';

use Test::More;
use Test::Number::Delta;

use DTA qw(driver_trip_value);

my $file = 'homebody-rotation';

my @tests = (
    {
        driver_trip => [ 1, 1 ],
        expected    => 2.085,
    },
    {
        driver_trip => [ 23, 8 ],
        expected    => -1.690,
    },
);

foreach my $test (@tests) {
    my @driver_trip = @{$test->{driver_trip}};

    my $value = driver_trip_value( @driver_trip, $file );
    my $message = sprintf 'Retrieved %s for driver %d trip %d', $file, @driver_trip;

    delta_within( $value, $test->{expected}, 0.002, $message );
}

done_testing();
