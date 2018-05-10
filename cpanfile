requires 'Mojolicious';
requires 'Algorithm::Cron';

on test => sub {
    requires 'Test::Mock::Time';
}