use strict;
use warnings;

use Math::Trig;
use Test::More;
use Test::Number::Delta;

my @origin = ( 0, 0 );
my $origin_as_str = point_to_str(\@origin);

my @points = (
    {
        prev => [ 1, 1 ],
        tests => [
            { current => [ 2, 2 ], expected => pi *  0 / 4 },
            { current => [ 1, 2 ], expected => pi *  1 / 4 },
            { current => [ 0, 2 ], expected => pi *  2 / 4 },
            { current => [ 0, 1 ], expected => pi *  3 / 4 },
            { current => [ 2, 1 ], expected => pi * -1 / 4 },
            { current => [ 2, 0 ], expected => pi * -2 / 4 },
            { current => [ 1, 0 ], expected => pi * -3 / 4 },
            { current => [ 0, 0 ], expected => pi *  4 / 4 },
        ],
    },
    {
        prev => [ -1, 1 ],
        tests => [
            { current => [ -2, 2 ], expected => pi *  0 / 4 },
            { current => [ -2, 1 ], expected => pi *  1 / 4 },
            { current => [ -2, 0 ], expected => pi *  2 / 4 },
            { current => [ -1, 0 ], expected => pi *  3 / 4 },
            { current => [ -1, 2 ], expected => pi * -1 / 4 },
            { current => [  0, 2 ], expected => pi * -2 / 4 },
            { current => [  0, 1 ], expected => pi * -3 / 4 },
            { current => [  0, 0 ], expected => pi *  4 / 4 },
        ],
    },
    {
        prev => [ -1, -1 ],
        tests => [
            { current => [ -2, -2 ], expected => pi *  0 / 4 },
            { current => [ -2, -1 ], expected => pi * -1 / 4 },
            { current => [ -2,  0 ], expected => pi * -2 / 4 },
            { current => [ -1,  0 ], expected => pi * -3 / 4 },
            { current => [ -1, -2 ], expected => pi *  1 / 4 },
            { current => [  0, -2 ], expected => pi *  2 / 4 },
            { current => [  0, -1 ], expected => pi *  3 / 4 },
            { current => [  0,  0 ], expected => pi *  4 / 4 },
        ],
    },
    {
        prev => [ 1, -1 ],
        tests => [
            { current => [  2, -2 ], expected => pi *  0 / 4 },
            { current => [  2, -1 ], expected => pi *  1 / 4 },
            { current => [  2,  0 ], expected => pi *  2 / 4 },
            { current => [  1,  0 ], expected => pi *  3 / 4 },
            { current => [  1, -2 ], expected => pi * -1 / 4 },
            { current => [  0, -2 ], expected => pi * -2 / 4 },
            { current => [  0, -1 ], expected => pi * -3 / 4 },
            { current => [  0,  0 ], expected => pi *  4 / 4 },
        ],
    },
);

foreach my $point (@points) {
    my $prev = $point->{prev};

    foreach my $test ( @{ $point->{tests} } ) {
        my $current = $test->{current};
        my $turn = get_turn( $prev, $current );

        my $message = sprintf(
            'Calculated turn from (%d,%d) to (%d,%d)',
            @{$prev}, @{$current} );

        delta_within( $turn, $test->{expected}, 0.00001, $message );
    }
}

sub get_turn {
    my $prev    = shift;
    my $current = shift;

    my $prev_as_str    = point_to_str($prev);
    my $current_as_str = point_to_str($current);

    my $turn = `( echo $origin_as_str; echo $prev_as_str; echo $current_as_str ) | bin/util/turning`;

    return $turn;
}

sub point_to_str {
    my $point = shift;

    return join ',', @{$point};
}

done_testing();
