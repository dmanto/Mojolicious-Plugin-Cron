use strict;
use warnings;

package Mojolicious::Plugin::Cron;
use Mojo::Base 'Mojolicious::Plugin';

use Carp 'croak';

our $VERSION = "0.001";

1;


=head1 NAME

Mojolicious::Plugin::Cron - a Cron-like helper for Mojolicious and Mojolicious::Lite projects

=head1 SYNOPSIS

  # Mojolicious::Lite
  plugin Cron;

  cron '*/5 9-17 * * *' => sub {
      my $c = shift;
      # do someting non-blocking but useful
  }

  get '/' => sub {...}

=head1 SEE ALSO

=for :list
* L<Mojolicious>
* L<Mojolicious::Plugins>
