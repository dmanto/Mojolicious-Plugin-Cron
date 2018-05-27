use Mojolicious::Lite;

plugin Cron => ('*/5 * * * * *' =>sub {
    app->log->info("Cron from $$")
});

app->start;