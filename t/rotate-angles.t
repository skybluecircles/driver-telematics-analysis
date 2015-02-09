#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Deep qw(cmp_deeply num);
use Math::Trig;

my @tests = ( 
    {
        angle => pi * ( -1 / 4 ),
        rotations => [
            (  1 / 1 ),
            (  1 / 2 ),
            ( -1 / 2 ),
            ( -7 / 8 ),
            ( -3 / 4 ),
        ],
        expected => [
            (  3 / 4 ),
            (  1 / 4 ),
            ( -3 / 4 ),
            (  7 / 8 ),
            ( -1 / 1 ),
        ],
        message_part => 'negative',
    },
    {
        angle => pi * ( 5 / 8 ),
        rotations => [
            ( -1 / 4 ),
            (  1 / 8 ),
            (  3 / 4 ),
            (  1 / 1 ),
            (  3 / 8 ),
        ],
        expected => [
            (  3 / 8 ),
            (  3 / 4 ),
            ( -5 / 8 ),
            ( -3 / 8 ),
            (  1 / 1 ),
        ],
        message_part => 'postive',
    },);

foreach my $test (@tests) {
    my $angle = $test->{angle};

    my @rotated;
    foreach my $rotation ( @{ $test->{rotations} } ) {
        $rotation *= pi;

        my $new_angle =
          `echo $angle | perl -n bin/util/rotate-angles $rotation`;
        chomp $new_angle;

        push @rotated, $new_angle;
    }

    my @expected = map { num( pi * $_, 0.000000001 ) } @{ $test->{expected} };
    my $message = sprintf 'Rotated %s angle', $test->{message_part};

    cmp_deeply( \@rotated, \@expected, $message );
}

done_testing();
