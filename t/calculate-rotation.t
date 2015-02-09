#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Number::Delta;
use Math::Trig;

my @tests = (
    {
        angle    => pi * (  1 / 8 ),
        expected => pi * (  3 / 8 ),
        message_part => 1,
    },
    {
        angle    => pi * (  3 / 4 ),
        expected => pi * ( -1 / 4 ),
        message_part => 2,
    },
    {
        angle    => pi * ( -5 / 8 ),
        expected => pi * ( -7 / 8 ),
        message_part => 3,
    },
    {
        angle    => pi * ( -1 / 8 ),
        expected => pi * (  5 / 8 ),
        message_part => 4,
    },
);

foreach my $test (@tests) {
    my $rotation = `perl bin/util/calculate-rotation $test->{angle}`;
    chomp $rotation;

    my $message = 'Calculated rotation for angle in quadrant ' . $test->{message_part};

    delta_within( $rotation, $test->{expected}, 1e-9, $message );
}

done_testing();
