use strict;
use warnings;

package Mojolicious::Plugin::Cron;
use Mojo::Base 'Mojolicious::Plugin';
use File::Spec;
use Mojo::File qw(path);
use Mojo::IOLoop;
use Algorithm::Cron;

use Carp 'croak';

our $VERSION = "0.002";
use constant CRON_DIR => 'mojo_cron_dir';
my $totcrons = 0;
my $crondir;

sub register {
  my ($self, $app) = @_;

  # $crondir = path(File::Spec->tmpdir)->child(CRON_DIR, '.cron_version')
  #   ->make_path->spurt($VERSION);

  $app->helper(cron => \&_cron);
}

sub _cron {
  my ($c, $crontab, $code) = @_;
  say STDERR "Helper cron called $crontab $code";
  $crontab and ref $crontab eq ''  or croak "crontab parameter not a string";
  $code    and ref $code eq 'CODE' or croak "code prameter in not CODE";
  my $cron = Algorithm::Cron->new(
    crontab => $crontab,
    base    => $c->config('cron') // 'local'
  );
  my $ncron = ++$totcrons;
  my $time  = time;

  # $crontab, $code, $cron, $ncron and $time will be part of the $task closure
  my $task;
  $task = sub {
    $time = $cron->next_time($time);
    Mojo::IOLoop->timer(
      ($time - time) => sub {
        $code->();
        $task->();
      }
    );
  };
  $task->();
}

1;

=encoding utf8

=head1 NAME

(work in progress)
Mojolicious::Plugin::Cron - a Cron-like helper for Mojolicious and Mojolicious::Lite projects

=head1 SYNOPSIS

  # Mojolicious::Lite
  plugin Cron;

  cron '*/5 9-17 * * *' => sub {
      my $c = shift;
      # do someting non-blocking but useful
  }

  get '/' => sub {...}

=head1 DESCRIPTION

L<Mojolicious::Plugin::Cron> is a L<Mojolicious> plugin that allows to schedule tasks
 directly from inside a Mojolicious application.
You should not consider it as a cron replacement, but as a method to make a proof of
concept of a project. Cron is really battle-tested, so final version should use it.

=head1 HELPERS

L<Mojolicious::Plugin::Cron> implements the following helpers.

=head2 cron

Define cron tasks.

# schedule non-blocking task every 10 minutes
$app->cron('*/10 * * * *' => sub {...});

=head1 METHODS

=head2 register

    $plugin->register

=head1 AUTHOR

Daniel Mantovani, C<dmanto@cpan.org>

=head1 COPYRIGHT AND LICENCE

Copyright 2018, Daniel Mantovani.

This library is free software; you may redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<Mojolicious::Plugins>

=cut
