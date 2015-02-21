package DTA::Dependencies::Node::HTML;

use strict;
use warnings;

use namespace::autoclean;

use Moose;
use MooseX::StrictConstructor;
use MooseX::Types::Moose qw(Str);

has file => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has level => (
    is       => 'ro',
    isa      => Str,    # enum( driver trip )
    required => 1,
);

__PACKAGE__->meta()->make_immutable();

1;
