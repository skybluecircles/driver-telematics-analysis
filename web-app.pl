use Mojolicious::Lite;

use strict;
use warnings;

get 'driver/:driver/:path' => sub {
    my $c    = shift;
    my $path = $c->stash( 'path' );
    $c->render(
        next     => $c->next_driver( $driver ),
        prev     => $c->prev_driver( $driver ),
        img      => "$path.svg",
        template => $path,
    );
    }

app->start;

__DATA__

@@ pin-wheel.html.ep
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
