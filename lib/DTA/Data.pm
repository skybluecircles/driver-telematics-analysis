package DTA::Data;

use strict;
use warnings;

use Moose;
use MooseX::StrictConstructor;

with 'DTA::Role::HasData';

__PACKAGE__->meta()->make_immutable();

1;
