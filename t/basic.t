use strict;
use warnings;
use Test::More tests => 1;

BEGIN {
  use_ok('Mojolicious::Plugin::Cron');
}

diag("Testing M::P::Cron $Mojolicious::Plugin::Cron::VERSION");
