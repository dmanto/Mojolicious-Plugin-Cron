use Test::Mock::Time;
use Test2::V0;
use Test::Mojo;
use Algorithm::Cron;
use Mojo::File 'tempdir';

use Mojolicious::Lite;

$ENV{MOJO_MODE} = 'test';
my %local_tstamps;
#my $tmpdir = tempdir('cron_XXXX')->remove_tree({keep_root => 1})->to_abs->to_string;
my $tmpdir = '/tmp';
plugin Config => {default => {cron => {dir => $tmpdir}}};
plugin Cron => (
  '*/10 15 * * *' => sub {
    $local_tstamps{fmt_time(localtime)}++;
    Mojo::IOLoop->stop;
  }
);

get '/' => {text => 'Hello, world'};

diag("Running $0, directory $tmpdir");
diag(`ls -lai $tmpdir/mojo_cron_dir/test`);
diag(`tail -n +1 $tmpdir/mojo_cron_dir/test/*.time`);

my $t = Test::Mojo->new;
$t->get_ok('/')->status_is(200);

# goto the future, next 15 hs local time (today or tomorrow)

ff(Algorithm::Cron->new(base => 'local', crontab => '0 15 * * *')
    ->next_time(time) - time);

undef %local_tstamps;
my @local_at13pm = localtime;
my $lday = substr fmt_time(@local_at13pm), 0, 10;

ff(3630);    # 1 h 30 secs from 3PM, local time

is \%local_tstamps,
  {
  "$lday 15:10" => 1,
  "$lday 15:20" => 1,
  "$lday 15:30" => 1,
  "$lday 15:40" => 1,
  "$lday 15:50" => 1,
  },         # no more because hour is always 15 utc
  'exact tstamps';

diag(`ls -lai $tmpdir/mojo_cron_dir`);
diag(`tail -n +1 $tmpdir/mojo_cron_dir/test/*.time`);

done_testing;

sub fmt_time {
  my @lt = reverse(@_[1 .. 5]);    # no seconds on tests
  $lt[0] += 1900;
  $lt[1]++;
  return sprintf("%04d-%02d-%02d %02d:%02d", @lt);
}
