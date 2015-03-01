use Mojolicious::Lite;

use strict;
use warnings;

use DTA::WebApp::Helper qw(
    next_driver next_trip
    prev_driver prev_trip
);

get 'driver/:driver/:path' => sub {
    my $c      = shift;
    my $driver = $c->stash( 'driver' );
    my $path   = $c->stash( 'path' );
    $c->render(
        next     => next_driver( $driver ),
        prev     => prev_driver( $driver ),
        img      => "$path.svg",
        template => $path,
    );
};

get 'driver/:driver/trip/:trip/:path' => sub {
    my $c      = shift;
    my $driver = $c->stash( 'driver' );
    my $trip   = $c->stash( 'trip' );
    my $path   = $c->stash( 'path' );
    $c->render(
        next     => next_trip( $trip ),
        prev     => prev_trip( $trip ),
        img      => "$path.svg",
        template => $path,
    );
};

app->start;

__DATA__

@@ pin-wheel.html.ep
% layout 'image-loop', action => undef

@@ orig-rotated-coordinates.html.ep
% layout 'image-loop', action => undef

@@ rotated-coordinates.html.ep
% layout 'image-loop', action => undef

@@ morphology.html.ep
%layout 'image-loop', action => 'morphology-with-coordinates'

@@ morphology-with-coordinates.html.ep
%layout 'image-loop', action => 'morphology'

@@ layouts/image-loop.html.ep
<!DOCTYPE html>
<html>
  <head>
    <script src="/js/shortcut.js" type="text/javascript"></script>
    <script>
      shortcut.add( "j", function() {
          document.getElementById('prev').click();
      });
      shortcut.add( "k", function() {
          document.getElementById('action').click();
      });
      shortcut.add( "l", function() {
          document.getElementById('next').click();
      });
    </script>
  </head>
  <body>
    <table>
      <tr>
        <td colspan=4><img src="<%= $img %>"></td>
      </tr>
      <tr>
        <td width="12%">&nbsp;</a></td>
        <td>
          <a href="../<%= $prev %>/<%= $path %>" id="prev">
            <h1><img src="/img/left-arrow.png" height="132" align="middle"></h1>
          </a>
        </td>
        <td width="20%">
          <a href="<%= $action %>" id="action"></a>
          <a href="../<%= $next %>/<%= $path %>" id="next">
            <h1><img src="/img/right-arrow.png" height="132" align="middle"></h1>
          </a>
        </td>
        <td width="7%">&nbsp;</td>
      </tr>
   </table>
  </body>
</html>
