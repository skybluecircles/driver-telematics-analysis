use Mojolicious::Lite;

use strict;
use warnings;

use lib './lib';

use DTA qw(next_driver_trip_by_homebody_distance prev_driver_trip_by_homebody_distance);

# my $dta = DTA->new();

helper next_trip => sub {
    my $c    = shift;
    my $trip = shift;

    return 1 if $trip == 200;
    return $trip + 1;
};

helper prev_trip => sub {
    my $c    = shift;
    my $trip = shift;

    return 200 if $trip == 1;
    return $trip - 1;
};

get '/driver/:driver/trip/:trip/:path/order-by/homebody-distance' => sub {
    my $c      = shift;
    my $driver = $c->stash('driver');
    my $trip   = $c->stash('trip');
    my $path   = $c->stash('path');
    $c->render(
        next => '../../'
          . next_driver_trip_by_homebody_distance( $driver, $trip ),
        prev => '../../'
          . prev_driver_trip_by_homebody_distance( $driver, $trip ),
        img      => "../../$path.svg",
        template => $path,
        path => "$path/order-by/homebody-distance",
    );
};

get '/driver/:driver/trip/:trip/:path' => sub {
    my $c    = shift;
    my $trip = $c->stash('trip');
    my $path = $c->stash('path');
    $c->render(
        next     => $c->next_trip($trip),
        prev     => $c->prev_trip($trip),
        img      => "$path.svg",
        template => $path,
    );
};

app->start;

__DATA__

@@ rotated-coordinates-just-calipers.html.ep
% layout 'image-loop'

@@ rotated-coordinates-with-calipers.html.ep
% layout 'image-loop'

@@ rotated-coordinates.html.ep
% layout 'image-loop'

@@ orig-rotated-coordinates.html.ep
% layout 'image-loop'

@@ layouts/image-loop.html.ep
<!DOCTYPE html>
<html>
  <head>
    <script src="/js/shortcut.js" type="text/javascript"></script>
    <script>
      shortcut.add( "j", function() {
          document.getElementById('prev').click();
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
          <a href="../<%= $next%>/<%= $path %>" id="next">
            <h1><img src="/img/right-arrow.png" height="132" align="middle"></h1>
          </a>
        </td>
        <td width="7%">&nbsp;</td>
      </tr>
   </table>
  </body>
</html>
