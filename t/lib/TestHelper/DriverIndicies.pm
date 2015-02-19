package TestHelper::DriverIndicies;

use strict;
use warnings;

use autodie qw(:all);
use namespace::autoclean;

use Moose;
use MooseX::StrictConstructor;
use MooseX::Types::Moose qw(ArrayRef);
use Path::Class;

has _driver_ids => (
    traits => [qw(Array)],
    is      => 'ro',
    isa     => ArrayRef,
    builder => '_build_driver_ids',
    lazy    => 1,
    handles => {
        _count => 'count',
        _get   => 'get',
    },
);

sub _build_driver_ids {
    return [
        file( qw(t test-data sorted-drivers.txt) )->slurp( chomp => 1 ) ];
}

sub get_random_driver_id {
    my $self = shift;

    my $rand_index = int(rand( $self->_count ));

    return $self->_get($rand_index);
}

__PACKAGE__->meta()->make_immutable();

1;
