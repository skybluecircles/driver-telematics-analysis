package DTA::Dependencies;

use strict;
use warnings;

use Moose;
use MooseX::StrictConstructor;

use DTA::Dependencies::Node::HTML;
use Forest::Tree;

with 'DTA::Role::HasData';

has distances_over_duration => (
    is      => 'ro',
    isa     => 'Forest::Tree',
    builder => '_build_distances_over_duration',
    lazy    => 1,
);

has distances => (
    is      => 'ro',
    isa     => 'Forest::Tree',
    builder => '_build_build_distances',
    lazy    => 1,
);

sub _build_distances_over_duration {
    my $self = shift;

    my $node = DTA::Dependencies::Node::HTML->new(
        file  => 'distances_over_duration',
        level => 'driver'
    );
    my @dependencies = qw(distances);

    return $self->_build_limb( $node, \@dependencies );
}

sub _build_distances {
    my $node = DTA::Dependencies::Node::Script->new(
        driver_files      => [qw(distances durations)],
        driver_trip_files => [qw(distance duration)],
        location          => 'bin/distances'
    );

    return $self->_build_limb($node);
}

sub satisfy {
    my $self      = shift;
    my $dependent = shift; # Forest::Tree
    my $driver_id = shift;

    return if !$self->$dependent;

    $node->satisfy($driver_id);
}

sub _build_limb {
    my $self         = shift;
    my $node         = shift;
    my $dependencies = shift;

    my $tree = Forest::Tree->new( node => $node );
    $tree->add_child( $self->$_ ) foreach @$dependencies;

    return $tree;
}

__PACKAGE__->meta()->make_immutable();

1;
