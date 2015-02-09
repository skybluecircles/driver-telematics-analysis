use Mojolicious::Lite;

use strict;
use warnings;

helper next_trip => sub {
    my $c = shift;
    my $trip = shift;

    return 1 if $trip == 200;
    return $trip + 1;
};

helper prev_trip => sub {
    my $c = shift;
    my $trip = shift;

    return 200 if $trip == 1;
    return $trip - 1;
};

get '/driver/:driver/trip/:trip/:path' => sub {
    my $c = shift;
    my $trip = $c->stash('trip');
    $c->render(
        next     => $c->next_trip($trip),
        prev     => $c->prev_trip($trip),
        template => $c->stash('path'),
    );
};

app->start;

__DATA__

@@ orig-rotated-coordinates.html.ep 
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
        <td colspan=4><img src="orig-rotated-coordinates.svg"></td>
      </tr>
      <tr>
        <td width="12%">&nbsp;</a></td>
        <td>
          <a href="../<%= $prev %>/orig-rotated-coordinates" id="prev">
            <h1><img src="/img/left-arrow.png" height="132" align="middle"></h1>
          </a>
        </td>
        <td width="20%"> 
          <a href="../<%= $next%>/orig-rotated-coordinates" id="next">
            <h1><img src="/img/right-arrow.png" height="132" align="middle"></h1>
          </a>
        </td>
        <td width="7%">&nbsp;</td>
      </tr>
   </table>
  </body>
</html>
