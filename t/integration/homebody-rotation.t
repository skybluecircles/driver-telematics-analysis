#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Number::Delta;
use Path::Class;

my $data = $ENV{DTA_DATA} // die 'Please define the environment variable DTA_DATA';

my $file = 'homebody-rotation';

my @tests = (
    {
        driver_trip => [ 1, 1 ],
        expected    => 2.085,
    },
);

foreach my $test (@tests) {
    my @driver_trip = @{$test->{driver_trip}};

    my $value = driver_trip_value( @driver_trip, $file );
    my $message = sprintf 'Retrieved %s for driver %d trip %d', $file, @driver_trip;

    delta_within( $value, $test->{expected}, 0.001, $message );
}

done_testing();

sub driver_trip_value {
    my $driver = shift;
    my $trip   = shift;
    my $file   = shift;

    my $value = driver_trip_file( $driver, $trip, $file )->slurp()
      ;    # don't know caller's context

    return $value;
}

sub driver_trip_file {
    my $driver = shift;
    my $trip   = shift;
    my $file   = shift;

    return file( $data, 'driver', $driver, 'trip', $trip, $file );
}
