#!/usr/bin/perl

use strict;
use warnings;

use lib './lib';

use Test::More;
use Test::Deep;

use DTA qw(driver_trip_value);

my $file = 'left-right-indicies';

my @tests = (
    {
        driver_trip => [ 1, 1 ],
        expected    => "798,262$/",
    },
);

foreach my $test (@tests) {
    my @driver_trip = @{ $test->{driver_trip} };

    my $value = driver_trip_value( @driver_trip, $file );
    my $message = sprintf 'Retrieved (%s) for driver %d trip %d', $file,
      @driver_trip;

    is( $value, $test->{expected}, $message );
}

done_testing();
