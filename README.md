[![Actions Status](https://github.com/dmanto/Mojolicious-Plugin-Cron/workflows/linux/badge.svg)](https://github.com/dmanto/Mojolicious-Plugin-Cron/actions) [![Actions Status](https://github.com/dmanto/Mojolicious-Plugin-Cron/workflows/windows/badge.svg)](https://github.com/dmanto/Mojolicious-Plugin-Cron/actions) [![Actions Status](https://github.com/dmanto/Mojolicious-Plugin-Cron/workflows/macos/badge.svg)](https://github.com/dmanto/Mojolicious-Plugin-Cron/actions)
# NAME

Mojolicious::Plugin::Cron - a Cron-like helper for Mojolicious and Mojolicious::Lite projects

# SYNOPSIS

    # Execute some job every 5 minutes, from 9 to 5 (4:55 actually)

    # Mojolicious::Lite

    plugin Cron => ( '*/5 9-16 * * *' => sub {
        my $target_epoch = shift;
        # do something non-blocking but useful
    });

    # Mojolicious

    $self->plugin(Cron => '*/5 9-16 * * *' => sub {
        # same here
    });

\# More than one schedule, or more options requires extended syntax

    plugin Cron => (
    sched1 => {
      base    => 'utc', # not needed for local time
      crontab => '*/10 15 * * *', # at every 10th minute past hour 15 (3:00 pm to 3:50 pm)
      code    => sub {
        # job 1 here
      }
    },
    sched2 => {
      crontab => '*/15 15 * * *', # at every 15th minute past hour 15 (3:00 pm to 3:45 pm)
      code    => sub {
        # job 2 here
      }
    });

# DESCRIPTION

[Mojolicious::Plugin::Cron](https://metacpan.org/pod/Mojolicious%3A%3APlugin%3A%3ACron) is a [Mojolicious](https://metacpan.org/pod/Mojolicious) plugin that allows to schedule tasks
 directly from inside a Mojolicious application.

The plugin mimics \*nix "crontab" format to schedule tasks (see [cron](https://en.wikipedia.org/wiki/Cron)) .

As an extension to regular cron, seconds are supported in the form of a sixth space
separated field (For more information on cron syntax please see [Algorithm::Cron](https://metacpan.org/pod/Algorithm%3A%3ACron)).

The plugin can help in development and testing phases, as it is very easy to configure and
doesn't require a schedule utility with proper permissions at operating system level.

For testing, it may be helpful to use Test::Mock::Time ability to "fast-forward"
time calling all the timers in the interval. This way, you can actually test events programmed
far away in the future.

For deployment phase, it will help avoiding the installation steps normally asociated with
scheduling periodic tasks.

# BASICS

When using preforked servers (as applications running with hypnotoad), some coordination
is needed so jobs are not executed several times.

[Mojolicious::Plugin::Cron](https://metacpan.org/pod/Mojolicious%3A%3APlugin%3A%3ACron) uses standard Fcntl functions for that coordination, to assure
a platform-independent behavior.

Please take a look in the examples section, for a simple Mojo Application that you can
run on a preforked server, try hot restarts, adding / removing workers, etc, and
check that scheduled jobs execute without interruptions or duplications.

# EXTENDEND SYNTAX HASH

When using extended syntax, you can define more than one crontab line, and have access
to more options

    plugin Cron => {key1 => {crontab line 1}, key2 => {crontab line 2}, ...};

## Keys

Keys are the names that identify each crontab line. They are used to form a locking 
semaphore file to avoid multiple processes starting the same job. 

You can use the same name in different Mojolicious applications that will run
at the same time. This will ensure that not more that one instance of the cron job
will take place at a specific scheduled time. 

## Crontab lines

Each crontab line consists of a hash with the following keys:

- base => STRING

    Gives the time base used for scheduling. Either `utc` or `local` (default `local`).

- crontab => STRING

    Gives the crontab schedule in 5 or 6 space-separated fields.

- sec => STRING, min => STRING, ... mon => STRING

    Optional. Gives the schedule in a set of individual fields, if the `crontab`
    field is not specified.

    For more information on base, crontab and other time related keys,
     please refer to [Algorithm::Cron](https://metacpan.org/pod/Algorithm%3A%3ACron) Constructor Attributes. 

- code => sub {...}

    Mandatory. Is the code that will be executed whenever the crontab rule fires.
    Note that this code **MUST** be non-blocking. For tasks that are naturally
    blocking, the recommended solution would be to enqueue tasks in a job 
    queue (like the [Minion](https://metacpan.org/pod/Minion) queue, that will play nicelly with any Mojo project).

# METHODS

[Mojolicious::Plugin::Cron](https://metacpan.org/pod/Mojolicious%3A%3APlugin%3A%3ACron) inherits all methods from
[Mojolicious::Plugin](https://metacpan.org/pod/Mojolicious%3A%3APlugin) and implements the following new ones.

## register

    $plugin->register(Mojolicious->new, {Cron => '* * * * *' => sub {}});

Register plugin in [Mojolicious](https://metacpan.org/pod/Mojolicious) application.

# MULTIHOST LOCKING

The epoch corresponding to the scheduled time (i.e. the perl "time" function
corresponding to the current task) is available as the first parameter for the
callback sub. This can be used as a higher level "lock" to limit the amount
of simultaneous scheduled tasks to just one on a multi-host environment.

(You will need some kind of db service accessible from all hosts).

    # Execute some job every 5 minutes, only on one of the existing hosts

    plugin Cron => ( '*/5 * * * *' => sub {
        my $target_epoch = shift;
        my $last_epoch = some_kind_of_atomic_swap_function(
          key => "some id key for this crontab",
          value => $target_epoch
          );
        if ($target_epoch != $last_epoc) { # Only first host will get here!
          # do something non-blocking
        } else {
          # following hosts will get here. Do not call the task
        }
    });

That "atomic\_swap" function **needs to be non-blocking**. As this is unlikely the
case because it will normally imply a remote call, you can just enqueue a job to a [Minion](https://metacpan.org/pod/Minion) queue
and then inside the task filter out already executed (by other host) tasks by this lock.
You can see a working proof of concept [here](https://github.com/dmanto/clustered-cron-example), using
an [etcd](https://etcd.io) db as a resilient backend to handle the atomic swap functionality.

# WINDOWS INSTALLATION

To install in windows environments, you need to force-install module
Test::Mock::Time, or installation tests will fail.

# AUTHOR

Daniel Mantovani, `dmanto@cpan.org`

# COPYRIGHT AND LICENCE

Copyright (C) 2018-2024, Daniel Mantovani.

This library is free software; you may redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

# SEE ALSO

[Mojolicious](https://metacpan.org/pod/Mojolicious), [Mojolicious::Guides](https://metacpan.org/pod/Mojolicious%3A%3AGuides), [Mojolicious::Plugins](https://metacpan.org/pod/Mojolicious%3A%3APlugins), [Algorithm::Cron](https://metacpan.org/pod/Algorithm%3A%3ACron), [Minion](https://metacpan.org/pod/Minion)
