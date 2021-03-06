use strict;
use warnings;

use Math::Trig;
use Test::Deep qw(cmp_deeply num);
use Test::More;
use Test::Number::Delta;

my $TOL = 0.00001;

QUADRANT_TESTS: {

    my @origin = ( 0, 0 );
    my $origin_as_str = point_to_str( \@origin );

    my @quadrant_tests = (
        {
            quadrant => 1,
            prev     => [ 1, 1 ],
            tests    => [
                { current => [ 2, 1 ], expected => pi * 0 / 4 },
                { current => [ 2, 2 ], expected => pi * 1 / 4 },
                { current => [ 1, 2 ], expected => pi * 2 / 4 },
                { current => [ 0, 2 ], expected => pi * 3 / 4 },
                { current => [ 0, 1 ], expected => pi * 4 / 4 },
                { current => [ 0, 0 ], expected => pi * -3 / 4 },
                { current => [ 1, 0 ], expected => pi * -2 / 4 },
                { current => [ 2, 0 ], expected => pi * -1 / 4 },
            ],
        },
        {
            quadrant => 2,
            prev     => [ -1, 1 ],
            tests    => [
                { current => [ 0,  1 ], expected => pi * 0 / 4 },
                { current => [ 0,  2 ], expected => pi * 1 / 4 },
                { current => [ -1, 2 ], expected => pi * 2 / 4 },
                { current => [ -2, 2 ], expected => pi * 3 / 4 },
                { current => [ -2, 1 ], expected => pi * 4 / 4 },
                { current => [ -2, 0 ], expected => pi * -3 / 4 },
                { current => [ -1, 0 ], expected => pi * -2 / 4 },
                { current => [ -0, 0 ], expected => pi * -1 / 4 },
            ],
        },
        {
            quadrant => 3,
            prev     => [ -1, -1 ],
            tests    => [
                { current => [ 0,  -1 ], expected => pi * 0 / 4 },
                { current => [ 0,  0 ],  expected => pi * 1 / 4 },
                { current => [ -1, 0 ],  expected => pi * 2 / 4 },
                { current => [ -2, 0 ],  expected => pi * 3 / 4 },
                { current => [ -2, -1 ], expected => pi * 4 / 4 },
                { current => [ -2, -2 ], expected => pi * -3 / 4 },
                { current => [ -1, -2 ], expected => pi * -2 / 4 },
                { current => [ 0,  -2 ], expected => pi * -1 / 4 },
            ],
        },
        {
            quadrant => 4,
            prev     => [ 1, -1 ],
            tests    => [
                { current => [ 2, -1 ], expected => pi * 0 / 4 },
                { current => [ 2, 0 ],  expected => pi * 1 / 4 },
                { current => [ 1, 0 ],  expected => pi * 2 / 4 },
                { current => [ 0, 0 ],  expected => pi * 3 / 4 },
                { current => [ 0, -1 ], expected => pi * 4 / 4 },
                { current => [ 0, -2 ], expected => pi * -3 / 4 },
                { current => [ 1, -2 ], expected => pi * -2 / 4 },
                { current => [ 2, -2 ], expected => pi * -1 / 4 },
            ],
        },
    );

    foreach my $quadrant_test (@quadrant_tests) {
        my $quadrant = $quadrant_test->{quadrant};

        subtest "Quadrant $quadrant" => sub {
            my $prev = $quadrant_test->{prev};

            foreach my $test ( @{ $quadrant_test->{tests} } ) {
                my $current = $test->{current};

                my $angle = interval_angle( $prev, $current );

                my $message =
                  sprintf( 'Calculated turn from (%d,%d) to (%d,%d)',
                    @{$prev}, @{$current} );

                delta_within( $angle, $test->{expected}, 0.00001, $message );
            }
        };
    }
}

SEQUENCE_TEST: {

    my @sequence =
      ( [ 0, 0 ], [ 1, 1 ], [ 0, 1 ], [ -1, 1 ], [ 0, 0 ], [ 1, -1 ] );

    my @angles = split "\n", interval_angle(@sequence);

    my @expected =
      ( pi * 1 / 4, pi * 4 / 4, pi * 4 / 4, pi * -1 / 4, pi * -1 / 4, );

    my @comparison = map { num( $_, $TOL ) } @expected;

    cmp_deeply( \@angles, \@comparison,
        "Calculated turns for multiple points in sequence" );
}

NO_MOVEMENT: {

    my @sequence = (
        [ 0, 0 ], [ 1, 1 ], [ 1, 1 ], [ 2, 2 ], [ 2, 3 ]
    );

    my @angles = split "\n", interval_angle(@sequence);

    my @expected = ( pi * 1 / 4, pi * 1 / 4, pi * 1 / 2 );
    my @comparison = map { num( $_, $TOL ) } @expected;

    cmp_deeply( \@angles, \@comparison, 'No output for identical, consecutive points' );
}

done_testing();

sub interval_angle {
    my $out = join "\n", map { point_to_str($_) } @_;

    return `( echo "$out" ) | bin/util/interval-angle`;
}

sub point_to_str {
    my $point = shift;

    return join ',', @{$point};
}
