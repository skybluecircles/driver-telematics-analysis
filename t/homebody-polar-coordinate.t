#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

my @tests = (
    {
        values   => [ '0,-1.34', '2,-1.01', '4,-1.25', '3,-0.99', ],
        expected => '4,-1.25',
        message  => 'from middle',
    },
    {
        values   => [ '15,2.38', '10,-3.14', '11,2.12', '9,-1.11', ],
        expected => '15,2.38',
        message  => 'from beginning',
    },
    {
        values   => [ '1,-0.95', '2,-1.01', '4,-1.25', '19,22.5' ],
        expected => '19,22.5',
        message  => 'at end',
    },
    {
        values   => [ '0,-1.34', '0,-1.34', '0,-1.34', '0,-1.34', '0,-1.34', ],
        expected => '0,-1.34',
        message  => 'when all same',
    },
    {
        values   => ['18,-2.51'],
        expected => '18,-2.51',
        message  => 'for single value',
    },
    {
        values   => [ '0,0', '0,0', '0,0', ],
        expected => '0,0',
        message  => 'when all zero',
    },
);

foreach my $test (@tests) {
    my $out = join $/, @{ $test->{values} };

    my $distance =
      `echo "$out" | perl -a -F, bin/util/homebody-polar-coordinate`;

    my $expected = $test->{expected} . $/;
    my $message  = 'Found homebody polar coordinate ' . $test->{message};

    is( $distance, $expected, $message );
}

done_testing();
