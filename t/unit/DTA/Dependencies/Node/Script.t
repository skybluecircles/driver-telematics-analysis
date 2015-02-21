use strict;
use warnings;

use feature qw(say);

# use Test::More;
use DTA::Data;
use DTA::Dependencies;

$ENV{DTA_DATA} = 't/test-data';

my $depenencies = DTA::Dependencies->new();


say $data->dta_data();
