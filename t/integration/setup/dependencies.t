use strict;
use warnings;

use Test::More;
use File::Which;
use Path::Class;

my $os = $^O;
ask_for_help() if ( $os ne 'darwin' && $os ne 'linux' );

my @dependencies = file( 'cpan.dependencies' )->slurp( chomp => 1 );
require_ok($_) foreach @dependencies;

ok( which($_), "Found ($_)" ) foreach qw(bash cc Rscript);

done_testing();

sub ask_for_help {
    my $message = <<'__MESSAGE__';


This program has only been tested on Linux and OSX.
It may work on others, but I don't know.

Any help improving the code's protability would be
greatly appreciated and pull requests are welcomed.

__MESSAGE__

    diag $message;
}
