package DTA;

use strict;
use warnings;

use autodie qw(:all);

use Hash::Ordered;
use Path::Class;
use Sub::Exporter -setup =>
  { exports => [qw/driver_trip_value driver_trip_values driver_trip_file driver_trip_line_value next_driver_trip_by_homebody_distance prev_driver_trip_by_homebody_distance/] };

use Test::More;

my $data = $ENV{DTA_DATA} // die 'Please define the environment variable DTA_DATA';

my %drivers_trips_homebody_ordered_index;

sub prev_driver_trip_by_homebody_distance {
    my $driver = shift;
    my $trip   = shift;

    my $index = get_index_by_homebody_distance_for_driver_trip( $driver, $trip, );

    my $prev_index = $index > 0 ? $index - 1 : 199;

    return get_trip_by_homebody_distance_for_driver_index( $driver, $prev_index );
}

sub next_driver_trip_by_homebody_distance {
    my $driver = shift;
    my $trip   = shift;

    my $index = get_index_by_homebody_distance_for_driver_trip( $driver, $trip, );

    my $next_index = $index < 199 ? $index + 1 : 0;

    return get_trip_by_homebody_distance_for_driver_index( $driver, $next_index );
}

sub get_trip_by_homebody_distance_for_driver_index {
    my $driver = shift;
    my $index = shift;

    my @keys = $drivers_trips_homebody_ordered_index{$driver}->keys();

    return $keys[$index];
}

sub get_index_by_homebody_distance_for_driver_trip {
    my $driver = shift;
    my $trip   = shift;

    if ( !exists $drivers_trips_homebody_ordered_index{$driver} ) {
        $drivers_trips_homebody_ordered_index{$driver} =
          make_driver_trips_homebody_ordered_index($driver);
    }

    return $drivers_trips_homebody_ordered_index{$driver}->get($trip);
}

sub make_driver_trips_homebody_ordered_index {
    my $driver = shift;

    my $lines = driver_file_values( $driver, 'trips-homebody-ordered-index' );

    return Hash::Ordered->new( map { my ( $trip, $index ) = split /,/; $trip => $index - 1 } @$lines );
}

sub driver_file_values {
    my $driver = shift;
    my $file   = shift;

    my @values = driver_file( $driver, $file )->slurp( chomp => 1 );

    return \@values;
}

sub driver_file {
    my $driver = shift;
    my $file   = shift;

    return file( $data, 'driver', $driver, $file );
}

sub driver_trip_line_value {
    my $driver = shift;
    my $trip   = shift;
    my $line   = shift;
    my $file   = shift;

    my $path = driver_trip_file( $driver, $trip, $file )->stringify();

    die "path ($path) does not exist$/" unless -f $path;

    return `sed -n ${line}p $path` // die "Line ($line) exceeds end of file";
}

sub driver_trip_values {
    my $driver = shift;
    my $trip   = shift;
    my $file   = shift;

    my @values = driver_trip_file( $driver, $trip, $file )->slurp( chomp => 1 )
      ;    # don't know caller's context

    return \@values;
}

sub driver_trip_value {
    my $driver = shift;
    my $trip   = shift;
    my $file   = shift;

    my $value = driver_trip_file( $driver, $trip, $file )->slurp()
      ;    # don't know caller's context

    return $value;
}

sub driver_trip_file {
    my $driver = shift;
    my $trip   = shift;
    my $file   = shift;

    return file( $data, 'driver', $driver, 'trip', $trip, $file );
}

1;
