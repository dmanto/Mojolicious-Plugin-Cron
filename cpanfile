requires 'Mojolicious';
requires 'Algorithm::Cron';

on test => sub {
    requires 'Test2::V0';
    requires 'Test::Mock::Time';
}