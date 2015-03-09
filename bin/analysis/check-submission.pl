use strict;
use warnings;

use Path::Class;

my $drivers = 2736;
my $trips   = 200;
my $lines   = $drivers * $trips;

my $fh = file( $ARGV[0] )->openr();

my $count_one;
my $count_zero;

readline $fh; # header

while ( readline $fh ) {
    chomp;
    my ( $driver_trip, $prob ) = split /,/;

    if ( $prob == 1 ) {
        $count_one++;
    }
    elsif ( $prob == 0 ) {
        $count_zero++;
    }
    else {
        warn sprintf 'Line %d has prob != 0 or 1: %s', $., $_;
    }
}

printf '1: %f%s', $count_one / $., $/;
printf '0: %f%s', $count_zero / $., $/;
