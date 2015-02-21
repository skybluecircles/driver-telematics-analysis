package DTA::Dependencies::Node::Script;

use strict;
use warnings;

use namespace::autoclean;

use Moose;
use MooseX::StrictConstructor;

with 'DTA::Role::HasData';

has command => (    # the name of the command in bin
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has driver_files => (
    is      => 'ro',
    isa     => Maybe [ArrayRef],
    default => undef,
);

has driver_trip_files => (
    is      => 'ro',
    isa     => Maybe [ArrayRef],
    default => undef,
);

sub satisfy {
    my $self    = shift;
    my $driver  = shift;
    my $trip_id = shift;

    my $command = sprintf 'bin/%s',
        $self->command;    # tighten security around this

    # The whole point of these dependencies is to
    # let someone start up the webserver and have
    # the images they want to look at (and the
    # data they depend on) generated as needed.

    # It could be better just to make the user
    # derive everything before visualizing it.

    if ( $self->_unsatisfied( $driver_id, $trip_id ) ) {
        `$command $driver_id`;

        if ( $self->_unsatisfied( $driver_id, $trip_id ) ) {
            die sprintf
                'Not able to satisfy requirements for driver (%d) command (%s)',
                $driver_id, $self->command;
        }
    }
}

sub _unsatisified {
    my $self      = shift;
    my $driver_id = shift;
    my $trip_id   = shift // 1;

    my $unsatisfied
        = any { !$self->driver_file_exists( $driver_id, $_ ) }
    $node->all_driver_files
        || any { !$self->driver_trip_file_exists( $driver_id, $trip_id, $_ ) }
    $node->all_driver_trip_files;

    return $unsatisfied;
}

__PACKAGE__->meta()->make_immutable();

1;
