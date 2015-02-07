#!/usr/bin/perl

use strict;
use warnings;

use Math::Trig;
use Test::More;

my @cartesian = ( '0,0', '5,0', '3,4', '0,6', '-2,3', '-3,0', '-1,-1', '0,-7', '5,-6' );
my @polar = map { `echo "$_" | perl -a -F, bin/util/cartesian-to-polar` } @cartesian;

my @expected = (
    coord( 0, 0 ),
    coord( 5, 0 ),
    coord( 5, atan2(4,3) ),
    coord( 6, pi/2 ),
    coord( sqrt(2**2 + 3**2), atan2(3,-2) ),
    coord( 3, pi ),
    coord( sqrt(2),  -3 / 4 * pi ),
    coord( 7, pi/-2 ),
    coord( sqrt(5**2 + 6**2), atan2(-6,5) ),
);

my $actual = split_coords(\@polar);
my $expected = split_coords(\@expected);

is_deeply( $actual, $expected, 'Converted cartesian coordinates to polar ones' );

done_testing();

sub coord {
    my $distance = shift;
    my $angle    = shift;

    return sprintf( '%f,%f%s', $distance, $angle, $/ );
}

sub split_coords {
    my $coords = shift;

    my %hash;
    foreach my $coord (@polar) {
        my ( $distance, $angle ) = split ',', $coord;

        push @{$hash{distance}}, $distance;
        push @{$hash{angle}}, $angle;
    }

    return \%hash;
}
