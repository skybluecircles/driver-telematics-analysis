package DTA;

use strict;
use warnings;

use autodie qw(:all);

use Path::Class;
use Sub::Exporter -setup =>
  { exports => [qw/driver_trip_value driver_trip_values driver_trip_file driver_trip_line_value/] };

my $data = $ENV{DTA_DATA} // die 'Please define the environment variable DTA_DATA';

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
