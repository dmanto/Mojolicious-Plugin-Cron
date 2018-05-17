# NAME

(work in progress)
Mojolicious::Plugin::Cron - a Cron-like helper for Mojolicious and Mojolicious::Lite projects

# SYNOPSIS

    # Mojolicious::Lite
    plugin Cron( '*/5 9-17 * * *' => sub {
        my $c = shift;
        # do someting non-blocking but useful
    });

    get '/' => sub {...}

# DESCRIPTION

[Mojolicious::Plugin::Cron](https://metacpan.org/pod/Mojolicious::Plugin::Cron) is a [Mojolicious](https://metacpan.org/pod/Mojolicious) plugin that allows to schedule tasks
 directly from inside a Mojolicious application.
You should not consider it as a \*nix cron replacement, but as a method to make a proof of
concept of a project. \*nix cron is really battle-tested, so final version should use it.

# HELPERS

[Mojolicious::Plugin::Cron](https://metacpan.org/pod/Mojolicious::Plugin::Cron) implements the following helpers.

## cron

Define cron tasks.

\# schedule non-blocking task every 10 minutes
$app->cron('\*/10 \* \* \* \*' => sub {...});

# METHODS

## register

    $plugin->register

# AUTHOR

Daniel Mantovani, `dmanto@cpan.org`

# COPYRIGHT AND LICENCE

Copyright 2018, Daniel Mantovani.

This library is free software; you may redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

# SEE ALSO

[Mojolicious](https://metacpan.org/pod/Mojolicious), [Mojolicious::Guides](https://metacpan.org/pod/Mojolicious::Guides), [Mojolicious::Plugins](https://metacpan.org/pod/Mojolicious::Plugins)
