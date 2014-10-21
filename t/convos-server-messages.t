use t::Helper;

plan skip_all => 'Live tests skipped. Set REDIS_TEST_DATABASE to "default" for db #14 on localhost or a redis:// url for custom.' unless $ENV{REDIS_TEST_DATABASE};

redis_do(
  [ hmset => 'user:doe', digest => 'E2G3goEIb8gpw', email => '' ],
  [ zadd => 'user:doe:conversations', time, 'irc:2eperl:2eorg:00:23convos', time - 1, 'irc:2eperl:2eorg:00batman' ],
  [ sadd => 'user:doe:connections', 'irc.perl.org' ],
  [ hmset => 'user:doe:connection:irc.perl.org', nick => 'doe' ],
  [ del => 'user:doe:connection:convos:msg' ],
);

my $connection = Convos::Core::Connection->new(server => 'irc.perl.org', login => 'doe');

$connection->redis($t->app->redis)->_irc(dummy_irc());;

$connection->add_server_message({
  params => ['doe', 'Welcome to the MAGnet Internet Relay Chat Network jhthorsen'],
  prefix => 'electret.shadowcat.co.uk',
  command => '001',
});

$connection->irc_mode({
  params => ['doe', '+i'],
  prefix => 'electret.shadowcat.co.uk',
});

$connection->irc_err_bannedfromchan({
  params => [ 'doe', '#mojo', 'Cannot join channel (+b)' ],
  prefix => 'electret.shadowcat.co.uk',
});

$connection->irc_error({
  params => [ 'some error', 'message' ],
  prefix => 'electret.shadowcat.co.uk',
});

$connection->redis->del('just:to:be:sure:data:has:been:stored', sub { Mojo::IOLoop->stop });
Mojo::IOLoop->start;

$t->post_ok('/login', form => { login => 'doe', password => 'barbar' })->status_is(302);
$t->get_ok('/convos')
  ->status_is(200)
  ->element_exists('div.messages ul li:first-child img[src="/avatar/convos@irc.perl.org"]')
  ->text_is('div.messages ul li:nth-of-child(1) h3 a', 'irc.perl.org')
  ->text_is('div.messages ul li:nth-of-child(1) div', 'Welcome to the MAGnet Internet Relay Chat Network jhthorsen')
  ->text_is('div.messages ul li:nth-of-child(2) div', 'You are connected to irc.perl.org with mode +i')
  ->text_is('div.messages ul li:nth-of-child(3) div', 'Cannot join channel (+b)')
  ->text_is('div.messages ul li:nth-of-child(4) div', 'some error message')
  ;

done_testing;

sub dummy_irc {
  no warnings;
  *test::dummy_irc::nick = sub { 'doe' };
  *test::dummy_irc::user = sub { '' };
  bless {}, 'test::dummy_irc';
}
