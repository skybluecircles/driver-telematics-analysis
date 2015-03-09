use strict;
use warnings;

use Path::Class;

my $drivers = 2736;
my $trips   = 200;
my $lines   = $drivers * $trips;

my $fh = file( $ARGV[0] )->openr();

my $count_one;
my $count_zero;

my @driver_ids = `ls $ENV{DTA_DATA}/driver/ | xargs basename | sort -n`;
my $driver_id = shift @driver_ids;

readline $fh; # header

my $i = 1;
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
        die "Line $. has prob != 0 or 1: $_";
    }

    my ( $this_driver_id, $trip_id ) = split /_/, $driver_trip;

    die "Expected ($i) for trip id for line ($.), but got ($trip_id): $_"
        if $trip_id != $i;

    die
        "Expected ($driver_id) for driver_id for line ($.), but got ($this_driver_id): $_"
        if $this_driver_id != $driver_id;

    if ( $i < 200 ) {
        $i++;
    }
    else {
        $i = 1;
        $driver_id = shift @driver_ids;
    }
}

die "Expected ($lines) lines, but got ($.)" if $. != $lines + 1;

printf '1: %f%s', $count_one / $., $/;
printf '0: %f%s', $count_zero / $., $/;
