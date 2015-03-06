use strict;
use warnings;

use Test::More;
use Test::Deep;
use Math::Trig;

$ENV{DTA_DATA} = 't/test-data/';

my $tol = 0.00001;

my @points = (
    [ 0, 0],
    [ 1, 1],
    [ 1, 2],
    [ 0, 2],
    [-1, 1],
    [-1, 2],
    [-1, 1],
    [-1, 0],
    [-0, 0],
    [ 1,-1],
    [ 2,-1],
    [ 3,-1],
    [ 2,-1],
);
my $out = join "\n", map { join ',', @$_ } @points;

my @rotations = `echo "$out" | bin/util/interval-angle | bin/util/rotation-between-angles`;

my @expected = (
    pi *  1 / 4,
    pi *  2 / 4,
    pi *  1 / 4,
    pi * -3 / 4,
    pi * -4 / 4,
    pi *  0 / 4,
    pi *  2 / 4,
    pi * -1 / 4,
    pi *  1 / 4,
    pi *  0 / 4,
    pi *  4 / 4,
);
my @comparison = map { num($_, $tol ) } @expected;

cmp_deeply( \@rotations, \@comparison, 'Calculated rotation between intervals for sequence' );

done_testing();
