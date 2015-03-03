use strict;
use warnings;

use Math::Trig;
use Test::Deep;
use Test::More;
use Test::Number::Delta;

my $TOL = 0.00001;

QUADRANT_TESTS: {

    my @quadrant_tests = (
        {
            quadrant => 1,
            prev => pi * 2 / 8,
            tests => [
                { current => pi *  2 / 8, expected => pi *  0 / 8 },
                { current => pi *  3 / 8, expected => pi *  1 / 8 },
                { current => pi *  4 / 8, expected => pi *  2 / 8 },
                { current => pi *  5 / 8, expected => pi *  3 / 8 },
                { current => pi *  6 / 8, expected => pi *  4 / 8 },
                { current => pi *  7 / 8, expected => pi *  5 / 8 },
                { current => pi *  8 / 8, expected => pi *  6 / 8 },
                { current => pi * -8 / 8, expected => pi *  6 / 8 },
                { current => pi * -7 / 8, expected => pi *  7 / 8 },
                { current => pi * -6 / 8, expected => pi *  8 / 8 },
                { current => pi *  1 / 8, expected => pi * -1 / 8 },
                { current => pi *  0 / 8, expected => pi * -2 / 8 },
                { current => pi *     -0, expected => pi * -2 / 8 },
                { current => pi * -1 / 8, expected => pi * -3 / 8 },
                { current => pi * -2 / 8, expected => pi * -4 / 8 },
                { current => pi * -3 / 8, expected => pi * -5 / 8 },
                { current => pi * -4 / 8, expected => pi * -6 / 8 },
                { current => pi * -5 / 8, expected => pi * -7 / 8 },
            ],
        },
        {
            quadrant => 2,
            prev => pi * 6 / 8,
            tests => [
                { current => pi *  6 / 8, expected => pi *  0 / 8 },
                { current => pi *  7 / 8, expected => pi *  1 / 8 },
                { current => pi *  8 / 8, expected => pi *  2 / 8 },
                { current => pi * -8 / 8, expected => pi *  2 / 8 },
                { current => pi * -7 / 8, expected => pi *  3 / 8 },
                { current => pi * -6 / 8, expected => pi *  4 / 8 },
                { current => pi * -5 / 8, expected => pi *  5 / 8 },
                { current => pi * -4 / 8, expected => pi *  6 / 8 },
                { current => pi * -3 / 8, expected => pi *  7 / 8 },
                { current => pi * -2 / 8, expected => pi *  8 / 8 },
                { current => pi *  5 / 8, expected => pi * -1 / 8 },
                { current => pi *  4 / 8, expected => pi * -2 / 8 },
                { current => pi *  3 / 8, expected => pi * -3 / 8 },
                { current => pi *  2 / 8, expected => pi * -4 / 8 },
                { current => pi *  1 / 8, expected => pi * -5 / 8 },
                { current => pi *  0 / 8, expected => pi * -6 / 8 },
                { current => pi *     -0, expected => pi * -6 / 8 },
                { current => pi * -1 / 8, expected => pi * -7 / 8 },
            ],
        },
        {
            quadrant => 3,
            prev => pi * -6 / 8,
            tests => [
                { current => pi * -6 / 8, expected => pi *  0 / 8 },
                { current => pi * -5 / 8, expected => pi *  1 / 8 },
                { current => pi * -4 / 8, expected => pi *  2 / 8 },
                { current => pi * -3 / 8, expected => pi *  3 / 8 },
                { current => pi * -2 / 8, expected => pi *  4 / 8 },
                { current => pi * -1 / 8, expected => pi *  5 / 8 },
                { current => pi *  0 / 8, expected => pi *  6 / 8 },
                { current =>          -0, expected => pi *  6 / 8 },
                { current => pi *  1 / 8, expected => pi *  7 / 8 },
                { current => pi *  2 / 8, expected => pi *  8 / 8 },
                { current => pi *  3 / 8, expected => pi * -1 / 8 },
                { current => pi *  4 / 8, expected => pi * -2 / 8 },
                { current => pi *  5 / 8, expected => pi * -3 / 8 },
                { current => pi *  6 / 8, expected => pi * -4 / 8 },
                { current => pi *  7 / 8, expected => pi * -5 / 8 },
                { current => pi *  8 / 8, expected => pi * -6 / 8 },
                { current => pi * -8 / 8, expected => pi * -6 / 8 },
                { current => pi * -7 / 8, expected => pi * -7 / 8 },
            ],
        },
        {
            quadrant => 4,
            prev => pi * -2 / 8,
            tests => [
                { current => pi * -2 / 8, expected => pi *  0 / 8 },
                { current => pi * -1 / 8, expected => pi *  1 / 8 },
                { current => pi *  0 / 8, expected => pi *  2 / 8 },
                { current =>          -0, expected => pi *  2 / 8 },
                { current => pi *  1 / 8, expected => pi *  3 / 8 },
                { current => pi *  2 / 8, expected => pi *  4 / 8 },
                { current => pi *  3 / 8, expected => pi *  5 / 8 },
                { current => pi *  4 / 8, expected => pi *  6 / 8 },
                { current => pi *  5 / 8, expected => pi *  7 / 8 },
                { current => pi *  6 / 8, expected => pi *  8 / 8 },
                { current => pi *  7 / 8, expected => pi * -7 / 8 },
                { current => pi *  8 / 8, expected => pi * -6 / 8 },
                { current => pi * -8 / 8, expected => pi * -6 / 8 },
                { current => pi * -7 / 8, expected => pi * -5 / 8 },
                { current => pi * -6 / 8, expected => pi * -4 / 8 },
                { current => pi * -5 / 8, expected => pi * -3 / 8 },
                { current => pi * -4 / 8, expected => pi * -2 / 8 },
                { current => pi * -3 / 8, expected => pi * -1 / 8 },
            ],
        },
    );

    foreach my $quadrant_test (@quadrant_tests) {
        my $quadrant = $quadrant_test->{quadrant};

        subtest "Quadrant $quadrant" => sub {
            my $prev = $quadrant_test->{prev};

            foreach my $test ( @{ $quadrant_test->{tests} } ) {
                my $current = $test->{current};

                my $rotation = rotation_between_angles( $prev, $current );

                my $message = sprintf(
                    'Calculated rotation between angles for (%d) and (%d)',
                    $prev, $current );

                delta_within( $rotation, $test->{expected}, $TOL, $message );
            }
        };
    }
}

SEQUENCE: {

    my @sequence = (
        pi *  0 / 8,
        pi *  1 / 2,
        pi * -7 / 8,
        pi *  1 / 8,
        pi *  1 / 8,
        pi * -2 / 8,
        pi *  0 / 8,
        pi *  5 / 8,
        -0,
    );

    my @rotations = rotation_between_angles(@sequence);

    my @expected = (
         pi *  1 / 2,
         pi *  5 / 8,
         pi *  8 / 8,
         pi *  0 / 8,
         pi * -3 / 8,
         pi *  2 / 8,
         pi *  5 / 8,
         pi * -5 / 8,
    );

    my @comparison = map { num( $_, $TOL ) } @expected;

    cmp_deeply( \@rotations, \@comparison, "Calculated rotations beteween multiple points in sequence" );

}

CORNER_CASES: {

    my @corner_cases = (
        {
            problem => 'prev is 0',
            prev => 0,
            tests => [
                { current => pi * -2 / 8, expected => pi *  0 / 8 },
            ],
        },
        {
            problem => 'prev is -0',
            prev => 0,
            tests => [
                { current => pi * -2 / 8, expected => pi *  0 / 8 },
            ],
        },
        {
            problem => 'prev is pi',
            prev => pi,
            tests => [
                { current => pi * -2 / 8, expected => pi *  0 / 8 },
            ],
        },
        {
            problem => 'prev is -pi',
            prev => pi,
            tests => [
                { current => pi * -2 / 8, expected => pi *  0 / 8 },
            ],
        },
    );
}

EXCEPTIONS: {

    my @exceptions = (
        {
            exception => 'prev < -pi',
            angles => [ pi * -1.3, pi * 1 / 2 ],
        },
        {
            exception => 'current < -pi',
            angles => [ pi * 1 / 2, pi * -1.3, ],
        },
        {
            exception => 'prev > pi',
            angles => [ pi * 1.3, pi * 1 / 2 ],
        },
        {
            exception => 'current > pi',
            angles => [ pi * 1 / 2, pi * 1.3, ],
        },
    );

}

done_testing();

sub rotation_between_angles {
    my $out = join "\n", map { point_to_str($_) } @_;

    return `echo $out | bin/util/rotation-between-angles`;
}

sub point_to_str {
    my $point = shift;

    return join ',', @{$point};
}
