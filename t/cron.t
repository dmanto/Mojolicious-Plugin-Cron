use Test::Mock::Time;
use Test::More;
use Test::Mojo;

#use Mojo::IOLoop;
use Mojolicious::Lite;

my @global_tstamps;
my @local_tstamps;

my $time_ini = time;
plugin 'Cron';
app->cron(
  '* * * * *' => sub {
    push @global_tstamps, [gmtime];
    push @local_tstamps,  [localtime];
    Mojo::IOLoop->stop;
  }
);

get '/' => {text => 'Hello, world'};
app->start;
my $t = Test::Mojo->new;
$t->get_ok('/')->status_is(200);

ff(600);    # ten minutes from now
is $local_tstamps[0][5], 118, 'Ok year';
# diag explain [@global_tstamps];
# diag explain [@local_tstamps];
done_testing;
