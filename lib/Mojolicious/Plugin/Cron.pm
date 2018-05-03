use strict;
use warnings;

package Mojolicious::Plugin::Cron;
use Mojo::Base 'Mojolicious::Plugin';

use Carp 'croak';

our $VERSION = "0.001";

# ABSTRACT: a Cron-like helper for Mojolicious and Mojolicious::Lite projects

=head1 SYNOPSIS

  ...

=method register

This method does something experimental.

=method method_y

This method returns a reason.

=head1 SEE ALSO

=for :list
* L<Mojolicious>
* L<Mojolicious::Plugins>
1;
