package Convos::Core::Connection;

=head1 NAME

Convos::Core::Connection - Represents a connection to an IRC server

=head1 SYNOPSIS

  use Convos::Core::Connection;

  $c = Convos::Core::Connection->new(
         name => 'magnet',
         login => 'username',
         redis => Mojo::Redis->new,
       );

  $c->connect;

  Mojo::IOLoop->start;

=head1 DESCRIPTION

This module use L<Mojo::IRC> to  up a connection to an IRC server. The
attributes used to do so is figured out from a redis server.

There are quite a few L<EVENTS|Mojo::IRC/EVENTS> that this module use:

=over 4

=item * L</add_message> events

L<Mojo::IRC/privmsg>.

=item * L</add_server_message> events

L<Mojo::IRC/rpl_yourhost>, L<Mojo::IRC/rpl_motdstart>, L<Mojo::IRC/rpl_motd>,
L<Mojo::IRC/rpl_endofmotd>, L<Mojo::IRC/rpl_welcome> and L<Mojo::IRC/error>.

=item * Other events

L</irc_rpl_welcome>, L</irc_rpl_myinfo>, L</irc_join>, L</irc_part>,
L</irc_rpl_namreply>, L</err_nosuchchannel>, L</err_notonchannel>, L</err_nosuchnick>
L</err_bannedfromchan>, l</irc_error> and L</irc_quit>.

=back

=cut

use Mojo::Base 'Mojo::EventEmitter';
use Mojo::IRC;
use Mojo::JSON 'j';
no warnings 'utf8';
use IRC::Utils;
use Parse::IRC   ();
use Scalar::Util ();
use Time::HiRes 'time';
use Convos::Core::Util qw( as_id id_as );
use Sys::Hostname ();
use constant CHANNEL_LIST_CACHE_TIMEOUT => 3600;    # TODO: Figure out how long to cache channel list
use constant DEBUG => $ENV{CONVOS_DEBUG} ? 1 : 0;

=head1 ATTRIBUTES

=head2 name

Name of the connection. Example: "freenode", "magnet" or "efnet".

=head2 log

Holds a L<Mojo::Log> object.

=head2 login

The username of the owner.

=head2 redis

Holds a L<Mojo::Redis> object.

=cut

has name  => '';
has log   => sub { Mojo::Log->new };
has login => 0;
has redis => sub { die 'redis connection required in constructor' };

my @ADD_MESSAGE_EVENTS        = qw( irc_privmsg ctcp_action irc_notice );
my @ADD_SERVER_MESSAGE_EVENTS = qw(
  irc_rpl_yourhost irc_rpl_motdstart irc_rpl_motd irc_rpl_endofmotd
  irc_rpl_welcome rpl_luserclient
);
my @OTHER_EVENTS = qw(
  irc_rpl_welcome irc_rpl_myinfo irc_join irc_nick irc_part irc_479
  irc_rpl_whoisuser irc_rpl_whoisidle irc_rpl_whoischannels irc_rpl_endofwhois
  irc_rpl_topic irc_topic
  irc_rpl_topicwhotime irc_rpl_notopic err_nosuchchannel err_nosuchnick
  err_notonchannel err_bannedfromchan irc_rpl_list
  irc_rpl_listend irc_mode irc_quit irc_kick irc_error
  irc_rpl_namreply irc_rpl_endofnames err_nicknameinuse
);

has _irc => sub {
  my $self = shift;
  my $irc = Mojo::IRC->new(debug_key => join ':', $self->login, $self->name);

  $irc->parser(Parse::IRC->new(ctcp => 1));

  Scalar::Util::weaken($self);
  $irc->register_default_event_handlers;
  $irc->on(close => sub { $self->_irc_close });
  $irc->on(error => sub { $self->_irc_error($_[1]) });

  for my $event (@ADD_MESSAGE_EVENTS) {
    $irc->on($event => sub { $self->add_message($_[1]) });
  }
  for my $event (@ADD_SERVER_MESSAGE_EVENTS) {
    $irc->on($event => sub { $self->add_server_message($_[1]) });
  }
  for my $event (@OTHER_EVENTS) {
    $irc->on($event => sub { $_[1]->{handled}++ or $self->$event($_[1]) });
  }

  $irc;
};

sub _irc_close {
  my $self = shift;
  my $name = $self->_irc->name;

  $self->_state('disconnected');

  if ($self->{stop}) {
    $self->_publish_and_save(server_message => {status => 200, message => 'Disconnected.'});
    return;
  }

  $self->_publish_and_save(server_message => {status => 500, message => "Disconnected from $name."});
  $self->_reconnect;
}

sub _irc_error {
  my ($self, $error) = @_;
  my $name = $self->_irc->name;

  $self->{stop} and return $self->_state('disconnected');
  $self->_state('disconnected');
  $self->_publish_and_save(server_message => {status => 500, message => "Connection to $name failed: $error"});
  $self->_reconnect;
}

=head1 METHODS

=head2 new

Checks for mandatory attributes: L</login> and L</name>.

=cut

sub new {
  my $self = shift->SUPER::new(@_);

  $self->{login} or die "login is required";
  $self->{name}  or die "name is required";
  $self->{conversation_path} = "user:$self->{login}:conversations";
  $self->{path}              = "user:$self->{login}:connection:$self->{name}";
  $self->{state}             = 'disconnected';
  $self;
}

=head2 connect

  $self = $self->connect;

This method will create a new L<Mojo::IRC> object with attribute data from
L</redis>. The values fetched from the backend is identified by L</name> and
L</login>. This method then call L<Mojo::IRC/connect> after the object is set
up.

Attributes fetched from backend: nick, user, host and channels. The latter
is set in L</channels> and used by L</irc_rpl_welcome>.

=cut

sub connect {
  my ($self) = @_;
  my $irc = $self->_irc;

  Scalar::Util::weaken($self);
  $self->{core_connect_timer} = 0;
  $self->{keepnick_tid} ||= $irc->ioloop->recurring(60 => sub { $self->_steal_nick });
  $self->_subscribe;

  $self->redis->execute(
    [hgetall => $self->{path}],
    [get     => 'convos:frontend:url'],
    sub {
      my ($redis, $args, $url) = @_;
      $self->redis->hset($self->{path} => tls => $self->{disable_tls} ? 0 : 1);
      $irc->name($url || 'Convos');
      $irc->nick($args->{nick} || $self->login);
      $irc->pass($args->{password}) if $args->{password};
      $irc->server($args->{server} || $args->{host});
      $irc->tls($self->{disable_tls} ? undef : {});
      $irc->user($args->{username} || $self->login);
      $irc->connect(
        sub {
          my ($irc, $error) = @_;
          $error and return $self->_connect_failed($error);
          $self->_publish_and_save(server_message => {status => 200, message => "Connected to IRC server"});
          $self->_state('connected');
        },
      );
    },
  );

  $self;
}

sub _state {
  my ($self, $state) = @_;

  $self->{state} = $state;
  $self->redis->hset($self->{path}, state => $state);
  $self;
}

sub _steal_nick {
  my $self = shift;

  # We will try to "steal" the nich we really want every 60 second
  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;
      $self->redis->hget($self->{path}, 'nick', $delay->begin);
    },
    sub {
      my ($delay, $nick) = @_;
      $self->_irc->write(NICK => $nick) if $nick and $self->_irc->nick ne $nick;
    }
  );
}

sub _subscribe {
  my $self = shift;
  my $irc  = $self->_irc;

  Scalar::Util::weaken($self);
  $self->{messages} = $self->redis->subscribe("convos:user:@{[$self->login]}:@{[$self->name]}");
  $self->{messages}->on(
    error => sub {
      my ($sub, $error) = @_;
      $self->log->warn("[$self->{path}] Re-subcribing to messages to @{[$irc->name]}. ($error)");
      $self->_subscribe;
    },
  );
  $self->{messages}->on(
    message => sub {
      my ($sub, $raw_message) = @_;
      my ($uuid, $message);

      $raw_message =~ s/(\S+)\s//;
      $uuid        = $1;
      $raw_message = sprintf ':%s %s', $irc->nick, $raw_message;
      $message     = Parse::IRC::parse_irc($raw_message);

      unless (ref $message) {
        $self->_publish_and_save(
          server_message => {status => 400, message => "Unable to parse: $raw_message", uuid => $uuid});
        return;
      }

      $message->{uuid} = $uuid;

      $irc->write(
        $raw_message,
        sub {
          my ($irc, $error) = @_;

          if ($error) {
            $self->_publish_and_save(server_message =>
                {status => 500, message => "Could not send message to @{[$irc->name]}: $error", uuid => $uuid});
          }
          elsif ($message->{command} eq 'PRIVMSG') {
            $self->add_message($message);
          }
          elsif (my $method = $self->can('cmd_' . lc $message->{command})) {
            $self->$method($message);
          }
        }
      );
    }
  );

  $self;
}

=head2 channels_from_conversations

  @channels = $self->channels_from_conversations(\@conversations);

This method returns an array ref of channels based on the conversations
input. It will use L</name> to filter out the right list.

=cut

sub channels_from_conversations {
  my ($self, $conversations) = @_;

  map { lc $_->[1] } grep { $_->[0] eq $self->name and $_->[1] =~ /^[#&]/ } map { [id_as $_ ] } @{$conversations || []};
}

=head2 add_server_message

  $self->add_server_message(\%message);

Will look at L<%message> and add it to the database as a server message
if it looks like one. Returns true if the message was added to redis.

=cut

sub add_server_message {
  my ($self, $message) = @_;
  my $params = $message->{params};
  my $data = {status => 200};

  shift @$params;    # I think this removes our own nick... Not quite sure though
  $data->{message} = join ' ', @$params;
  $message->{command} ||= '';

  $self->_state('connected');
  $self->_publish_and_save(server_message => $data);
}

=head2 add_message

  $self->add_message(\%message);

Will add a private message to the database.

=cut

sub add_message {
  my ($self, $message) = @_;
  my $current_nick       = $self->_irc->nick;
  my $is_private_message = $message->{params}[0] eq $current_nick;
  my $data = {highlight => 0, message => $message->{params}[1], timestamp => time, uuid => $message->{uuid},};

  @$data{qw( nick user host )} = IRC::Utils::parse_user($message->{prefix}) if $message->{prefix};
  $data->{target} = lc($is_private_message ? $data->{nick} : $message->{params}[0]);
  $data->{host} ||= 'localhost';

  if ($data->{nick}) {
    if ($data->{nick} eq $current_nick) {
      $data->{user} ||= $self->_irc->user;
    }
    elsif ($is_private_message or $data->{message} =~ /\b$current_nick\b/) {
      $self->_add_conversation($data->{target}) if $is_private_message and $data->{user};
      $data->{highlight} = 1;
    }
  }

  if (!$data->{user}) {    # server notice/message
    return $self->add_server_message($message);
  }

  # need to take care of when the current user also writes /me...
  # this is not yet tested, since i have no time right now :(
  if ($data->{message} =~ s/\x{1}ACTION (.*)\x{1}/$1/) {
    $message->{command} = "CTCP_ACTION";
  }

  $self->_publish_and_save($message->{command} eq 'CTCP_ACTION' ? 'action_message' : 'message', $data);
}

sub _add_conversation {
  my ($self, $target) = @_;
  my $name = as_id $self->name, $target;

  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;
      $self->redis->zincrby($self->{conversation_path}, 0, $name, $delay->begin);
    },
    sub {
      my ($delay, $part_of_conversation_list) = @_;
      $part_of_conversation_list and return;
      $self->redis->zrevrange($self->{conversation_path}, 0, 0, 'WITHSCORES', $delay->begin);
    },
    sub {
      my ($delay, $score) = @_;
      $self->redis->zadd($self->{conversation_path}, $score->[1] - 0.0001, $name, $delay->begin);
    },
    sub {
      my ($delay) = @_;
      $self->_publish(add_conversation => {target => $target});
    },
  );
}

=head2 disconnect

Will disconnect from the L</irc> server.

=cut

sub disconnect {
  my ($self, $cb) = @_;
  $self->{stop} = 1;
  $self->_irc->disconnect($cb || sub { });
}

=head1 EVENT HANDLERS

=head2 irc_rpl_welcome

Example message:

:Zurich.CH.EU.Undernet.Org 001 somenick :Welcome to the UnderNet IRC Network, somenick

=cut

sub irc_rpl_welcome {
  my ($self, $message) = @_;

  $self->{attempts} = 0;

  Scalar::Util::weaken($self);
  $self->redis->zrange(
    $self->{conversation_path},
    0, -1,
    sub {
      for my $channel ($self->channels_from_conversations($_[1])) {
        $self->redis->hget(
          "$self->{path}:$channel",
          key => sub {
            $_[1] ? $self->_irc->write(JOIN => $channel, $_[1]) : $self->_irc->write(JOIN => $channel);
          }
        );
      }
    }
  );
}

=head2 irc_rpl_endofwhois

Use data from L</irc_rpl_whoisidle>, L</irc_rpl_whoisuser> and
L</irc_rpl_whoischannels>.

=cut

sub irc_rpl_endofwhois {
  my ($self, $message) = @_;
  my $nick = $message->{params}[1];
  my $whois = delete $self->{whois}{$nick} || {};

  $whois->{channels} ||= [];
  $whois->{idle}     ||= 0;
  $whois->{realname} ||= '';
  $whois->{user}     ||= '';
  $whois->{nick} = $nick;
  $self->_publish(whois => $whois) if $whois->{host};
}

=head2 irc_rpl_whoisidle

Store idle info internally. See L</irc_rpl_endofwhois>.

=cut

sub irc_rpl_whoisidle {
  my ($self, $message) = @_;
  my $nick = $message->{params}[1];

  $self->{whois}{$nick}{idle} = $message->{params}[2] || 0;
}

=head2 irc_rpl_whoisuser

Store user info internally. See L</irc_rpl_endofwhois>.

=cut

sub irc_rpl_whoisuser {
  my ($self, $message) = @_;
  my $params = $message->{params};
  my $nick   = $params->[1];

  $self->{whois}{$nick}{host}     = $params->[3];
  $self->{whois}{$nick}{realname} = $params->[5];
  $self->{whois}{$nick}{user}     = $params->[2];
}

=head2 irc_rpl_whoischannels

Reply with user channels

=cut

sub irc_rpl_whoischannels {
  my ($self, $message) = @_;
  my $nick = $message->{params}[1];

  push @{$self->{whois}{$nick}{channels}}, split ' ', $message->{params}[2] || '';
}

=head2 irc_rpl_notopic

  :server 331 nick #channel :No topic is set.

=cut

sub irc_rpl_notopic {
  my ($self, $message) = @_;
  my $target = lc $message->{params}[1];

  $self->redis->hset("$self->{path}:$target", topic => '');
  $self->_publish(topic => {topic => '', target => $target});
}

=head2 irc_rpl_topic

Reply with topic

=cut

sub irc_rpl_topic {
  my ($self, $message) = @_;
  my $target = lc $message->{params}[1];
  my $topic  = $message->{params}[2];

  $self->redis->hset("$self->{path}:$target", topic => $topic);
  $self->_publish(topic => {topic => $topic, target => $target});
}

=head2 irc_topic

  :nick!~user@hostname TOPIC #channel :some topic

=cut

sub irc_topic {
  my ($self, $message) = @_;
  my $target = lc $message->{params}[0];
  my $topic  = $message->{params}[1];

  $self->redis->hset("$self->{path}:$target", topic => $topic);
  $self->_publish(topic => {topic => $topic, target => $target});
}

=head2 irc_rpl_topicwhotime

Reply with who and when for topic change

=cut

sub irc_rpl_topicwhotime {
  my ($self, $message) = @_;

  $self->_publish(topic_by =>
      {timestamp => $message->{params}[3], nick => $message->{params}[2], target => lc $message->{params}[1],});
}

=head2 irc_rpl_myinfo

Example message:

:Tampa.FL.US.Undernet.org 004 somenick Tampa.FL.US.Undernet.org u2.10.12.14 dioswkgx biklmnopstvrDR bklov

=cut

sub irc_rpl_myinfo {
  my ($self, $message) = @_;
  my @keys = qw/ current_nick real_host version available_user_modes available_channel_modes /;
  my $i    = 0;

  $self->redis->hmset($self->{path}, map { $_, $message->{params}[$i++] // '' } @keys);
}

=head2 irc_479

Invalid channel name.

=cut

sub irc_479 {
  my ($self, $message) = @_;

  # params => [ 'nickname', '1', 'Illegal channel name' ],
  $self->_publish(server_message => {status => 400, message => $message->{params}[2] || 'Illegal channel name'});
}

=head2 irc_join

See L<Mojo::IRC/irc_join>.

=cut

sub irc_join {
  my ($self, $message) = @_;
  my ($nick, $user, $host) = IRC::Utils::parse_user($message->{prefix});
  my $channel = lc $message->{params}[0];

  if ($nick eq $self->_irc->nick) {
    $self->redis->hset("$self->{path}:$channel", topic => '');
    $self->redis->hset("convos:host2convos" => $host => 'loopback');
    $self->_add_conversation($channel);
  }
  else {
    $self->_publish(nick_joined => {nick => $nick, target => $channel});
  }
}

=head2 irc_nick

  :old_nick!~username@1.2.3.4 NICK :new_nick

=cut

sub irc_nick {
  my ($self, $message) = @_;
  my ($old_nick) = IRC::Utils::parse_user($message->{prefix});
  my $new_nick = $message->{params}[0];

  if ($new_nick eq $self->_irc->nick) {
    delete $self->{supress}{err_nicknameinuse};
    $self->redis->hset($self->{path}, current_nick => $new_nick);
  }

  $self->_publish(nick_change => {old_nick => $old_nick, new_nick => $new_nick});
}

=head2 irc_quit

  {
    params => [ 'Quit: leaving' ],
    raw_line => ':nick!~user@localhost QUIT :Quit: leaving',
    command => 'QUIT',
    prefix => 'nick!~user@localhost'
  };

=cut

sub irc_quit {
  my ($self, $message) = @_;
  my ($nick) = IRC::Utils::parse_user($message->{prefix});

  Scalar::Util::weaken($self);
  $self->_publish(nick_quit => {nick => $nick, message => $message->{params}[0]});
}

=head2 irc_kick

  'raw_line' => ':testing!~marcus@home.means.no KICK #testmore :marcus_',
  'params' => [ '#testmore', 'marcus_' ],
  'command' => 'KICK',
  'handled' => 1,
  'prefix' => 'testing!~marcus@40.101.45.31.customer.cdi.no'

=cut

sub irc_kick {
  my ($self, $message) = @_;
  my ($by)    = IRC::Utils::parse_user($message->{prefix});
  my $channel = lc $message->{params}[0];
  my $nick    = $message->{params}[1];

  if ($nick eq $self->_irc->nick) {
    my $name = as_id $self->name, $channel;
    $self->redis->zrem($self->{conversation_path}, $name, sub { });
  }

  $self->_publish(nick_kicked => {by => $by, nick => $nick, target => $channel});
}

=head2 irc_part

=cut

sub irc_part {
  my ($self, $message) = @_;
  my ($nick) = IRC::Utils::parse_user($message->{prefix});
  my $channel = lc $message->{params}[0];

  Scalar::Util::weaken($self);
  if ($nick eq $self->_irc->nick) {
    my $name = as_id $self->name, $channel;

    $self->redis->zrem(
      $self->{conversation_path},
      $name,
      sub {
        $self->_publish(remove_conversation => {target => $channel});
      }
    );
  }
  else {
    $self->_publish(nick_parted => {nick => $nick, target => $channel});
  }
}

=head2 err_bannedfromchan

:electret.shadowcat.co.uk 474 nick #channel :Cannot join channel (+b)

=cut

sub err_bannedfromchan {
  my ($self, $message) = @_;
  my $channel = lc $message->{params}[1];
  my $name = as_id $self->name, $channel;

  $self->_publish_and_save(server_message => {status => 401, message => $message->{params}[2]});

  Scalar::Util::weaken($self);
  $self->redis->zrem(
    $self->{conversation_path},
    $name,
    sub {
      $self->_publish(remove_conversation => {target => $channel});
    }
  );
}

=head2 err_nicknameinuse

=cut

sub err_nicknameinuse {
  my ($self, $message) = @_;

  if ($self->{supress}{err_nicknameinuse}++) {
    return;
  }

  $self->_publish(server_message => {status => 500, message => $message->{params}[2],});
}

=head2 err_nosuchchannel

:astral.shadowcat.co.uk 403 nick #channel :No such channel

=cut

sub err_nosuchchannel {
  my ($self, $message) = @_;
  my $channel = lc $message->{params}[1];
  my $name = as_id $self->name, $channel;

  $self->_publish(server_message => {status => 400, message => qq(No such channel "$channel")});

  if ($channel =~ /^[#&]/) {
    Scalar::Util::weaken($self);
    $self->redis->zrem(
      $self->{conversation_path},
      $name,
      sub {
        $self->_publish(remove_conversation => {target => $channel});
      }
    );
  }
}

=head2 err_nosuchnick

  :electret.shadowcat.co.uk 442 sender nick :No such nick

=cut

sub err_nosuchnick {
  my ($self, $message) = @_;

  $self->_publish(err_nosuchnick => {nick => $message->{params}[1]});
}

=head2 err_notonchannel

:electret.shadowcat.co.uk 442 nick #channel :You're not on that channel

=cut

sub err_notonchannel {
  shift->err_nosuchchannel(@_);
}

=head2 irc_rpl_endofnames

Example message:

  :magnet.llarian.net 366 somenick #channel :End of /NAMES list.

=cut

sub irc_rpl_endofnames {
  my ($self, $message) = @_;
  my $channel = lc $message->{params}[1] or return;
  my $nicks = delete $self->{nicks}{$channel} || [];

  $self->_publish(rpl_namreply => {nicks => $nicks, target => $channel});
}

=head2 irc_rpl_namreply

Example message:

  :Budapest.Hu.Eu.Undernet.org 353 somenick = #channel :somenick Indig0 Wildblue @HTML @CSS @Luch1an @Steaua_ Indig0_ Pilum @fade

=cut

sub irc_rpl_namreply {
  my ($self, $message) = @_;
  my $channel = lc $message->{params}[2] or return;
  my $nicks = $self->{nicks}{$channel} ||= [];

  for my $nick (sort { lc $a cmp lc $b } split /\s+/, $message->{params}[3]) {    # 3 = "+nick0 @nick1 nick2"
    my $mode = $nick =~ s/^([@~+*])// ? $1 : '';
    push @$nicks, {nick => $nick, mode => $mode};
  }
}

=head2 irc_rpl_list

:servername 322 somenick #channel 10 :[+n] some topic

=cut

sub irc_rpl_list {
  my ($self, $message) = @_;
  my $network = $self->name;
  my $name    = $message->{params}[1];
  my %info    = (name => $name, visible => $message->{params}[2], title => $message->{params}[3] // '');

  $self->_publish(channel_info => {name => $name, network => $network, info => \%info});
  $self->redis->hset("convos:irc:$network:channels", $name => j \%info) if $self->{save_channels};
}

=head2 irc_rpl_listend

:servername 323 somenick :End of /LIST

=cut

sub irc_rpl_listend {
  my ($self, $message) = @_;
  my $network = $self->name;

  $self->redis->expire("convos:irc:$network:channels", CHANNEL_LIST_CACHE_TIMEOUT) if delete $self->{save_channels};
}

=head2 irc_mode

  :nick!user@host MODE #channel +o othernick
  :nick!user@host MODE yournick +i

=cut

sub irc_mode {
  my ($self, $message) = @_;
  my $target = lc shift @{$message->{params}};
  my $mode   = shift @{$message->{params}};

  if ($target eq lc $self->_irc->nick) {
    $self->_publish(server_message =>
        {status => 200, target => $self->name, message => "You are connected to @{[$self->name]} with mode $mode"});
  }
  else {
    $self->_publish(mode => {target => $target, mode => $mode, args => join(' ', @{$message->{params}})});
  }
}

=head2 irc_error

Example message:

ERROR :Closing Link: somenick by Tampa.FL.US.Undernet.org (Sorry, your connection class is full - try again later or try another server)

=cut

sub irc_error {
  my ($self, $message) = @_;

  # Server dislikes us, we'll back off more
  $self->{attempts} += 10;
  $self->_publish_and_save(server_message => {status => 500, message => join(' ', @{$message->{params}})});
}

=head2 cmd_nick

Handle nick commands from user. Change nick and set new nick in redis.

=cut

sub cmd_nick {
  my ($self, $message) = @_;
  my $new_nick = $message->{params}[0];

  if ($new_nick =~ /^[\w-]+$/) {
    $self->redis->hset($self->{path}, nick => $new_nick);
    $self->_publish(server_message => {status => 200, message => 'Set nick to ' . $new_nick});
  }
  else {
    $self->_publish(server_message => {status => 400, message => 'Invalid nick'});
  }
}

=head2 cmd_join

Store keys on channel join.

=cut

sub cmd_join {
  my ($self, $message) = @_;

  my $channel = $message->{params}[0];
  if (my $key = $message->{params}[1]) {
    $self->redis->hset("$self->{path}:$channel", key => $key);
  }
}

=head2 cmd_list

=cut

sub cmd_list {
  my ($self, $message) = @_;
  my $network = $self->name;

  $self->{channels} = {};

  if (my $filter = $message->{params}[0] || '') {
    $self->{channels}{lc($_)} = {name => $_, topic => '', not_found => 1} for split /,/, $filter;
  }
  else {
    $self->redis->del("convos:irc:$network:channels");
    $self->{save_channels} = 1;
  }
}

sub _connect_failed {
  my ($self, $error) = @_;
  my $server = $self->_irc->server;

  # SSL connect attempt failed with unknown error
  # error:140770FC:SSL routines:SSL23_GET_SERVER_HELLO:unknown protocol
  if ($error =~ /SSL\d*_GET_SERVER_HELLO/) {
    $self->_state('reconnecting');
    $self->_publish_and_save(
      server_message => {status => 400, message => "This IRC network ($server) does not support SSL/TLS."});
    $self->{disable_tls}        = 1;
    $self->{core_connect_timer} = 1;
  }
  else {
    $self->_state('disconnected');
    $self->_publish_and_save(server_message => {status => 500, message => "Could not connect to $server: $error"});
    $self->_reconnect;
  }
}

sub _publish {
  my ($self, $event, $data) = @_;
  my $login = $self->login;
  my $name  = $self->name;
  my $message;

  local $data->{state} = $self->{state};

  $data->{event}   = $event;
  $data->{network} = $name;
  $data->{timestamp} ||= time;
  $data->{uuid} ||= Mojo::Util::md5_sum($data->{timestamp} . $$);    # not really an uuid
  $message = j $data;

  if ($event eq 'server_message' and $data->{status} != 200) {
    $self->log->warn("[$login:$name] $data->{message}");
  }

  $self->redis->publish("convos:user:$login:out", $message);
  $message;
}

sub _publish_and_save {
  my ($self, $event, $data) = @_;
  my $login = $self->login;
  my $message = $self->_publish($event, $data);

  if ($data->{highlight}) {

    # Ooops! This must be broken: We're clearing the notification by index in
    # Client.pm, but the index we're clearing does not have to be the index in
    # the list. The bug should appear if we use an old ?notification=42 link
    # and in the meanwhile we have added more notifications..?
    $self->redis->lpush("user:$login:notifications", $message);
  }

  if ($data->{target}) {
    $self->redis->zadd("$self->{path}:$data->{target}:msg", $data->{timestamp}, $message);
  }
  else {
    $self->redis->zadd("$self->{path}:msg", $data->{timestamp}, $message);
  }

  $self->emit(save => $data);
}

sub _reconnect {
  my $self = shift;
  $self->{attempts}++;
  shift->{core_connect_timer} = 30 * $self->{attempts};    # CONNECT_INTERVAL * 30 = 60 seconds
}

sub DESTROY {
  warn "DESTROY $_[0]->{path}\n" if DEBUG;
  my $self         = shift;
  my $ioloop       = $self->{_irc}{ioloop} or return;
  my $keepnick_tid = $self->{keepnick_tid} or return;
  $ioloop->remove($keepnick_tid);
}

=head1 COPYRIGHT

See L<Convos>.

=head1 AUTHOR

Jan Henning Thorsen

Marcus Ramberg

=cut

1;
