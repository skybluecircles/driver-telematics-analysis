#!/usr/bin/perl

use strict;
use warnings;

use lib './lib';

use Test::More;
use Test::Number::Delta;

use DTA qw(driver_trip_line_value);

my $file = 'rotated-homebody-angles';

my @tests = (
    {
        driver_trip_line => [ 1, 1, 863 ],
        expected         => -2.14667055866496,
    },
);

foreach my $test (@tests) {
    my @driver_trip_line = @{ $test->{driver_trip_line} };

    my $value = driver_trip_line_value( @driver_trip_line, $file );

    my $message =
      sprintf 'Rotated homebody angle for driver %d trip %d at line %d',
      @driver_trip_line;

    delta_within( $value, $test->{expected}, 0.005, $message );
}

done_testing();
