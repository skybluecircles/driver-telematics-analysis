package DTA::WebApp::Helper;

use strict;
use warnings;

use autodie qw(:all);

use Sub::Exporter -setup=> {
    exports => [qw(next_driver prev_driver)],
};

my %drivers_index;
my %indicies_driver;

my $max_index;
my $min_index = 0;

_build_id_index_map();

sub next_driver {
    my $driver = shift;

    my $index = $drivers_index{$driver};

    if ( $index < $max_index ) {
        $index++;
        return $indicies_driver{$index};
    }

    return $indicies_driver{$min_index};
}

sub prev_driver {
    my $driver = shift;

    my $index = $drivers_index{$driver};

    if ( $index > $min_index ) {
        $index--;
        return $indicies_driver{$index};
    }

    return $indicies_driver{$max_index};
}

sub _build_id_index_map {
    my $index; 
    my $file = 'sorted-driver-ids';
    open( my $in, '<', $file ) || die "Could not open file ($file): $!";

    while( my $driver = readline $in ) {
        chomp $driver;
        $index = $. - 1;

        $drivers_index{$driver} = $index;
        $indicies_driver{$index} = $driver;
    }
    $max_index = $index;
}

1;
