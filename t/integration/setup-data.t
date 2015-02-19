#!/usr/bin/perl

use strict;
use warnings;

use lib 't/lib';

use Test::More;
use Test::Deep;
use TestHelper::DriverIndicies;
use Path::Class;
use Regexp::Common qw(number);

my $data = $ENV{DTA_DATA};

if ( !defined $data ) {
    BAIL_OUT( "DTA_DATA must be defined" );
}

ok( -d "$data/driver", 'Directory (driver) exists in data' );

my $helper = TestHelper::DriverIndicies->new();

# Testing 3 random drivers

for ( 1 .. 3 ) {
    my $id = $helper->get_random_driver_id();

    subtest "driver $id" => sub {

        ok( -d "$data/driver/$id", "Driver $id has directory" );

        my $trip_dir = "$data/driver/$id/trip";

        ok( -d "$trip_dir", "Driver $id has trip subdir" );

        my @trips = sort { $a->basename <=> $b->basename }
            dir( $trip_dir )->children();

        my @actual_basenames   = map { $_->basename } @trips;
        my @expected_basenames = map {$_} 1 .. 200;

        is_deeply( \@actual_basenames, \@expected_basenames,
            "driver $id has directory for each trip id" );

        subtest 'trips' => sub {
            foreach my $trip ( @trips ) {
                my $basename = $trip->basename;
                my $file     = $trip->file( 'coordinates' );
                ok( -s $file->stringify,
                    sprintf(
                        'Trip %d has coordinates file with non-zero size',
                        $trip->basename )
                );
            }

            for ( 1 .. 3 ) {
                my $rand_trip_id = int( rand( 200 ) );
                my $rand_trip    = $trips[$rand_trip_id];

                my @lines
                    = $rand_trip->file( 'coordinates' )->slurp( chomp => 1 );
                my @comparison = map { re( $RE{num}{real} ) } @lines;

                cmp_deeply( \@lines, \@comparison,
                    "Each line in ($rand_trip_id/coordinates) is well-formed"
                );
            }
        };
    };
}

my $symlink = './public/driver';
ok( -l $symlink, "$symlink is a symlink" );

my $actual_target = readlink $symlink;
my $expected_target = "$data/driver";

is( $actual_target, $expected_target, 'Symlinked public/driver to $DTA_DATA/driver' );

done_testing();
