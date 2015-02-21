package DTA::Role::HasData;

use strict;
use warnings;

use Moose::Role;
use MooseX::Types::Path::Class qw(Dir);

has dta_data => (
    is      => 'ro',
    isa     => Dir,
    builder => '_build_dta_data',
    coerce  => 1,
    lazy    => 1,
);

sub _build_dta_data {
    my $data = $ENV{DTA_DATA};

    if ( ! $data ) {
        die "Please define the environment variable DTA_DATA";
    }

    return $data;
}

sub driver_file_exists {
    my $self   = shift;
    my $driver = shift;
    my $file   = shift;

    return unless ( $driver && $file );
    return -e $self->dta_data->file( 'driver', $driver, $file )->stringify();
}

sub driver_trip_file_exists {
    my $self   = shift;
    my $driver = shift;
    my $trip   = shift;
    my $file   = shift;

    return unless ( $driver && $trip && $file );
    return -e $self->dta_data->file( 'driver', $driver, 'trip', $trip, $file )
        ->stringify();
}

1;
