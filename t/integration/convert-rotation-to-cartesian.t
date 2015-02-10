#!/usr/bin/perl

use strict;
use warnings;

use lib './lib';

use Test::More;
use Test::Deep;

use DTA qw(driver_trip_line_value);

my $file = 'coordinates-cartesian-rotated';
my $tolerance = 0.001;

my @tests = (
    {
        driver_trip_line => [ 1, 15, 271 ],
        comparison       => [
            num( -22.671890556,  $tolerance ),
            num( 1130.052594076, $tolerance ),
        ],
    },
    {
        driver_trip_line => [ 1132, 159, 35 ],
        comparison       => [
            num( 8.804643453,    $tolerance ),
            num( -139.719212185, $tolerance ),
        ],
    },
    {
        driver_trip_line => [ 1729, 99, 125 ],
        comparison       => [
            num( 127.832890895,  $tolerance ),
            num( 2154.915546374, $tolerance ),
        ],
    },
);

foreach my $test (@tests) {
    my @driver_trip_line = @{ $test->{driver_trip_line} };

    my $value = driver_trip_line_value( @driver_trip_line, $file );
    my @coords = split /,/, $value;

    my $message =
      sprintf
'Converted rotated polar coordinate for driver %d trip %d at line %d back to cartesian',
      @driver_trip_line;

    cmp_deeply( \@coords, $test->{comparison}, $message );
}

done_testing();
