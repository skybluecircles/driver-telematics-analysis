use Mojolicious::Lite;

use strict;
use warnings;

use DTA::Dependencies;
use Data::Dumper;

my $dependencies = DTA::Dependencies->new();

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

get '/' => 'index';

get '/driver/:driver/:path' => sub {
    my $c = shift;

    my $path = $c->stash( 'path' );
    my $driver = $c->stash( 'driver');

    $dependencies->satisfy( $path, $driver );
};

get '/driver/:driver/trip/:trip/:path' => sub {
    my $c    = shift;
    my $trip = $c->stash( 'trip' );
    my $path = $c->stash( 'path' );
    $c->render(
        next     => $c->next_trip( $trip ),
        prev     => $c->prev_trip( $trip ),
        img      => "$path.svg",
        template => $path,
    );
};

app->start;

__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html>
  <head>
    <title>DTA - Driver Telematics Analysis</title>
    <style>
      body {
          font-family: "Trebuchet MS", Helvetica, sans-serif;
          background: #BCE8FF;
      }

      h1 {
          font-size: 2.0em;
          color: #AC8359;
      }

      a {
          text-decoration:none;
      }

      a:link {
          color: #4C4C4C
      }

      a:visited {
          color: #949494
      }

      a:hover {
          color: #8DA38D
      }

      a.links {
          font-size: 1.45em;
      }
    </style>
  </head>
  <body>
    <table>
      <tr>
        <td colspan=2>
          <h1>DTA - Driver Telematics Analysis</h1>
        </td>
      </tr>
      <tr>
        <td> &nbsp; </td>
        <td> <a href="driver/1/trip/1/coordinates-orig-rotated" class="links"> > rotated-coordinates</a> </td>
      </tr>
      <tr>
        <td width="25px"> &nbsp; </td>
        <td> <a href="driver/1/trip/1/coordinates-rotated" class="links"> > orig-rotated-coordinates</a> </td>
      </tr>
      </table>
  </body>
</html>

@@ coordinates-rotated.html.ep
% layout 'image-loop'

@@ coordinates-orig-rotated.html.ep
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
