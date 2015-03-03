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
                { current => pi *  1 / 8, expected => pi * -1 / 8 },
                { current => pi *  3 / 8, expected => pi *  1 / 8 },
                { current => pi *  6 / 8, expected => pi *  4 / 8 },
                { current => pi *  8 / 8, expected => pi *  6 / 8 },
                { current => pi *  0 / 8, expected => pi * -2 / 8 },
                { current => pi * -3 / 8, expected => pi * -5 / 8 },
                { current => pi * -5 / 8, expected => pi * -7 / 8 },
                { current => pi * -6 / 8, expected => pi *  8 / 8 },
                { current => pi * -7 / 8, expected => pi *  7 / 8 },
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

sub rotation_between_angles {
    my $prev    = shift;
    my $current = shift;

    my $out = join "\n", $prev, $current;

    return `echo $out | bin/util/rotation-between-angles`;
}

done_testing();        
