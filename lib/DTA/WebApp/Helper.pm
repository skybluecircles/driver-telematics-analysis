package DTA::WebApp::Helper;

use strict;
use warnings;

use autodie qw(:all);

use Regexp::Common qw(number);
use Sub::Exporter -setup => {
    exports => [
        qw(
            next_driver next_trip
            prev_driver prev_trip
            )
    ],
};

my %drivers_index;
my %indicies_driver;

my $max_index;
my $min_index = 0;

build_indicies();

my $first_trip = 1;
my $last_trip = 200;

sub next_driver {
    my $driver = shift;

    my $index = $drivers_index{$driver} // die "No index for driver ($driver)";

    if ( $index < $max_index ) {
        $index++;
        return $indicies_driver{$index};
    }

    return $indicies_driver{$min_index};
}

sub next_trip {
    my $trip = shift;

    validate_trip($trip);

    if ( $trip < $last_trip ) {
        return $trip + 1;
    }
    return $first_trip;
}

sub prev_driver {
    my $driver = shift;

    my $index = $drivers_index{$driver} // die "No index for driver ($driver)";

    if ( $index > $min_index ) {
        $index--;
        return $indicies_driver{$index};
    }

    return $indicies_driver{$max_index};
}

sub prev_trip {
    my $trip = shift;

    validate_trip($trip);

    if ( $trip > $first_trip ) {
        return $trip - 1;
    }
    return $last_trip;
}

sub validate_trip {
    my $trip = shift;

    unless ( $trip =~ qr/^$RE{num}{int}$/ && $trip >= $first_trip && $trip <= $last_trip )
    {
        die
            "Trip ($trip) is invalid. Must be an int between $first_trip and $last_trip, inclusive";
    }
}

sub build_indicies {
    my $index;
    my $file = 'sorted-driver-ids';
    open( my $in, '<', $file ) || die "Could not open file ($file): $!";

    while( my $driver = readline $in ) {
        chomp $driver;
        $index = $. - 1;

        $drivers_index{$driver} = $index;
        $indicies_driver{$index} = $driver;
    }
    $max_index = $index;
}

1;
