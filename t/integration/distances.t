#!/usr/bin/env perl

use strict;
use warnings;

use feature qw(say);

use Test::More;
use Test::Deep qw(cmp_deeply num);
use File::Remove qw(remove);
use Path::Class;

my $data = $ENV{DTA_DATA} = 't/test-data/';
my $driver = 1;
my $trip   = 1;
my $base   = "$data/driver/$driver/trip/$trip";
my $tol    = 0.00001;

cleanup();

`bin/distances $driver $trip $trip`;

my @expected = (
    {   file       => 'distances',
        comparison => [ num( 1.4142135623, $tol ), num( 5, $tol ) ],
    },
    {   file       => 'distance',
        comparison => [ num( 6.41421356237, $tol ) ],
    },
    {   file       => 'duration',
        comparison => [2],
    },
);

foreach my $expectation ( @expected ) {
    my $file = $expectation->{file};
    my $message = sprintf( 'Created (%s) from coordinates', $file );

    my @data = file( $base, $file )->slurp( chomp => 1 );
    cmp_deeply( \@data, $expectation->{comparison}, $message );
}

cleanup();

sub cleanup {
    my @files = qw(distances distance duration);
    foreach my $file ( @files ) {
        if ( -f "$base/$file" ) {
            remove( "$base/$file" );
        }
    }
}
