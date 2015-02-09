package DTA;

use strict;
use warnings;

use autodie qw(:all);

use Path::Class;
use Sub::Exporter -setup =>
  { exports => [qw/driver_trip_value driver_trip_file/] };

my $data = $ENV{DTA_DATA} // die 'Please define the environment variable DTA_DATA';

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
