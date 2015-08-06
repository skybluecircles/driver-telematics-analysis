#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

my $data = $ENV{DTA_DATA};

ok( defined $data, 'DTA_DATA is defined' );
ok( -d $data, 'DTA_DATA points to an existant directory' );

done_testing();
