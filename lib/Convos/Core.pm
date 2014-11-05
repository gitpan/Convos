package Convos::Core;

=head1 NAME

Convos::Core - TODO

=head1 SYNOPSIS

TODO

=cut

use Mojo::Base -base;
use Mojo::JSON 'j';
use Mojolicious::Validator;
use Convos::Core::Connection;
use Convos::Core::Util qw( as_id id_as );
use Time::HiRes qw( time );
use constant DEBUG => $ENV{CONVOS_DEBUG} // 0;

my %CONVOS_MESSAGE = (
  event  => 'message',
  host   => 'loopback',
  nick   => 'convos',
  server => 'loopback',
  status => 200,
  target => 'convos',
  user   => 'convos',
);

=head1 ATTRIBUTES

=head2 archive

Holds a L<Convos::Archive::File> object.

=head2 log

Holds a L<Mojo::Log> object.

=head2 redis

Holds a L<Mojo::Redis> object.

=cut

has archive => sub { require Convos::Archive::File; Convos::Archive::File->new; };
has log     => sub { Mojo::Log->new };
has redis   => sub { die 'redis connection required in constructor' };

=head1 METHODS

=head2 control

  $self->control($command, $cb);

Used to issue a control command.

=cut

sub control {
  my ($self, @args) = @_;
  my $cb = pop @args;

  $self->redis->lpush('core:control', join(':', @args), $cb);
  $self;
}

=head2 reset

  $self = $self->reset;

Used to reset connection stats when backend is restarted.

=cut

sub reset {
  my $self  = shift;
  my $redis = $self->redis;

  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;
      $redis->del('convos:backend:lock');
      $redis->del('convos:host2convos');
      $redis->del('convos:loopback:names');    # clear loopback nick list
      $redis->hset('convos:host2convos', localhost => 'loopback');
      $redis->smembers('connections', $delay->begin);
    },
    sub {
      my ($delay, $connections) = @_;

      warn sprintf "[core] Reset %s connection(s)\n", int @$connections if DEBUG;
      for my $conn (@$connections) {
        my ($login, $name) = split /:/, $conn;
        $redis->hmset("user:$login:connection:$name", state => "disconnected", current_nick => "");
      }
    },
  );

  return $self;
}

=head2 start

Will fetch connection information from the database and try to connect to them.

=cut

sub start {
  my ($self, $cb) = @_;

  Scalar::Util::weaken($self);
  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;
      $self->reset;
      $self->redis->smembers('connections', $delay->begin);
    },
    sub {
      my ($delay, $connections) = @_;

      warn sprintf "[core] Starting %s connection(s)\n", int @$connections if DEBUG;
      for my $conn (@$connections) {
        my ($login, $name) = split /:/, $conn;
        $self->_connection(login => $login, name => $name)->connect;
      }
      $self->$cb if $cb;
    },
  );

  $self->_start_control_channel;
  $self;
}

sub _connection {
  my ($self, %args) = @_;
  my $conn = $self->{connections}{$args{login}}{$args{name}};

  unless ($conn) {
    Scalar::Util::weaken($self);
    $conn = Convos::Core::Connection->new(redis => $self->redis, log => $self->log, %args);
    $conn->on(save => sub { $_[1]->{message} and $_[1]->{timestamp} and $self->archive->save(@_); });
    $self->{connections}{$args{login}}{$args{name}} = $conn;
  }

  $conn;
}

sub _start_control_channel {
  my $self = shift;
  my $cb;

  Scalar::Util::weaken($self);

  $cb = sub {
    my ($redis, $instruction) = @_;
    $redis->brpop($instruction->[0], 0, $cb);
    $instruction->[1] or return;
    my ($command, $login, $name) = split /:/, $instruction->[1];
    my $action = "ctrl_$command";
    $self->$action($login, $name);
  };

  $self->{control} = Mojo::Redis->new(server => $self->redis->server);
  $self->{control}->$cb(['core:control']);
  $self->{control}->on(
    error => sub {
      my ($redis, $error) = @_;
      $self->log->warn("[core:control] $error (reconnecting)");
      Mojo::IOLoop->timer(0.5, sub { $self and $self->_start_control_channel });
    },
  );
}

=head2 add_connection

  $self->add_connection({
    login => $str,
    name => $str,
    nick => $str,
    server => $str, # irc_server[:port]
  }, $callback);

Add a new connection to redis. Will create a new connection id and
set all the keys in the %connection hash

=cut

sub add_connection {
  my ($self, $input, $cb) = @_;
  my $validation = $self->_validation($input, qw( login name nick password server username ));

  if ($validation->has_error) {
    $self->$cb($validation, undef);
    return $self;
  }

  my ($login, $name) = $validation->param([qw( login name )]);

  warn "[core:$login] add ", _dumper($validation->output), "\n" if DEBUG;
  Scalar::Util::weaken($self);
  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;
      $self->redis->exists("user:$login:connection:$name", $delay->begin);
    },
    sub {
      my ($delay, $exists) = @_;

      if ($exists) {
        $validation->error(name => ['exists']);
        $self->$cb($validation, undef);
        return;
      }

      $self->redis->execute(
        [sadd  => "connections",                  "$login:$name"],
        [sadd  => "user:$login:connections",      $name],
        [hmset => "user:$login:connection:$name", %{$validation->output}],
        $delay->begin,
      );
    },
    sub {
      my ($delay, @saved) = @_;
      $self->control(start => $login, $name, $delay->begin);
    },
    sub {
      my ($delay, $started) = @_;
      $self->$cb(undef, $validation->output);
    },
  );
}

=head2 update_connection

  $self->update_connection({
    login => $str,
    name => $str,
    nick => $str,
    server => $str, # irc_server[:port]
  }, $callback);

Update a connection's settings. This might issue a reconnect or issue
IRC commands to reflect the changes.

=cut

sub update_connection {
  my ($self, $input, $cb) = @_;
  my $validation = $self->_validation($input, qw( login name nick password server username ));

  if ($validation->has_error) {
    $self->$cb($validation, undef);
    return $self;
  }

  my ($login, $name) = $validation->param([qw( login name )]);
  my $conn  = Convos::Core::Connection->new(%{$validation->output});
  my $redis = $self->redis;

  warn "[core:$login] update ", _dumper($validation->output), "\n" if DEBUG;

  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;
      $redis->hgetall("user:$login:connection:$name", $delay->begin);
    },
    sub {
      my ($delay, $current) = @_;

      unless ($current and %$current) {
        $validation->error(name => ['no_such_connection']);
        $self->$cb($validation, undef);
        return;
      }

      $delay->begin->(@_);    # pass on $current and $conversations
      $redis->zrange("user:$login:conversations", 0, 1, $delay->begin);
      $redis->hmset("user:$login:connection:$name", $validation->output, $delay->begin);
    },
    sub {
      my ($delay, $current, $conversations) = @_;

      $conn = $validation->output;    # get rid of the extra junk from Connection->new()

      if ($current->{server} ne $conn->{server}) {
        $self->control(restart => $login, $name, sub { });
        $self->$cb(undef, $conn);
        return;
      }
      if ($current->{nick} ne $conn->{nick}) {
        warn "[core:$login] NICK $conn->{nick}\n" if DEBUG;
        $redis->publish("convos:user:$login:$name", "dummy-uuid NICK $conn->{nick}");
      }

      $self->$cb(undef, $conn);
    },
  );

  return $self;
}

=head2 delete_connection

  $self->delete_connection({
    login => $str,
    name => $str,
  }, $cb);

=cut

sub delete_connection {
  my ($self, $input, $cb) = @_;
  my $validation = $self->_validation($input);

  $validation->required('login');
  $validation->required('name');

  if ($validation->has_error) {
    $self->$cb($validation);
    return $self;
  }

  my ($login, $name) = $validation->param([qw( login name )]);

  warn "[core:$login] delete $name\n" if DEBUG;
  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;
      $self->redis->del("user:$login:connection:$name", $delay->begin);
      $self->redis->srem("connections",             "$login:$name", $delay->begin);
      $self->redis->srem("user:$login:connections", $name,          $delay->begin);
    },
    sub {
      my ($delay, @removed) = @_;

      unless ($removed[0]) {
        $validation->error(name => ['no_such_connection']);
        $self->$cb($validation);
        return $self;
      }

      $self->redis->keys("user:$login:connection:$name*", $delay->begin);    # jht: not sure if i like this...
      $self->redis->zrange("user:$login:conversations", 0, -1, $delay->begin);
      $self->control(stop => $login, $name, $delay->begin);
    },
    sub {
      my ($delay, $keys, $conversations) = @_;
      $self->redis->del(@$keys, $delay->begin) if @$keys;
      $self->redis->zrem("user:$login:conversations", $_) for grep {/^$name\b/} @$conversations;
      $self->$cb(undef);
    },
  );
}

=head2 ctrl_stop

  $self->ctrl_stop($login, $server);

Stop a connection by connection id.

=cut

sub ctrl_stop {
  my ($self, $login, $server) = @_;

  Scalar::Util::weaken($self);

  if (my $conn = $self->{connections}{$login}{$server}) {
    $conn->disconnect(sub { delete $self->{connections}{$login}{$server} });
  }
}

=head2 ctrl_restart

  $self->ctrl_restart($login, $server);

Restart a connection by connection id.

=cut


sub ctrl_restart {
  my ($self, $login, $server) = @_;

  Scalar::Util::weaken($self);

  if (my $conn = $self->{connections}{$login}{$server}) {
    $conn->disconnect(
      sub {
        delete $self->{connections}{$login}{$server};
        $self->ctrl_start($login => $server);
      }
    );
  }
  else {
    $self->ctrl_start($login => $server);
  }
}

=head2 ctrl_start

Start a single connection by connection id.

=cut

sub ctrl_start {
  my ($self, $login, $name) = @_;
  $self->_connection(login => $login, name => $name)->connect;
}

=head2 login

  $self->login({ login => $str, password => $str }, $callback);

Will call callback after authenticating the user. C<$callback> will receive
either:

  $callback->($self, ''); # success
  $callback->($self, 'error message'); # on error

=cut

sub login {
  my ($self, $input, $cb) = @_;
  my $validation = $self->_validation($input);

  $validation->required('login');
  $validation->required('password');

  if ($validation->has_error) {
    $self->$cb($validation);
    return $self;
  }

  Mojo::IOLoop->delay(
    sub {
      my $delay = shift;
      $self->redis->hget("user:" . $validation->param('login'), "digest", $delay->begin);
    },
    sub {
      my ($delay, $digest) = @_;
      if (!$digest) {
        $validation->error(login => ['no_such_user']);
        $self->$cb($validation);
      }
      elsif ($digest eq crypt scalar $validation->param('password'), $digest) {
        warn "[core:@{[$validation->param('login')]}] Valid password\n" if DEBUG;
        $self->$cb(undef);
      }
      else {
        $validation->error(login => ['invalid_password']);
        $self->$cb($validation);
      }
    }
  );
}

sub _dumper {    # function
  Data::Dumper->new([@_])->Indent(0)->Sortkeys(1)->Terse(1)->Dump;
}

sub _validation {
  my ($self, $input, @names) = @_;
  my $validation;

  if (UNIVERSAL::isa($input, 'Mojolicious::Validator::Validation')) {
    $validation = $input;
  }
  else {
    $validation = Mojolicious::Validator->new->validation;
    $validation->input($input);
  }

  for my $k (@names) {
    if    ($k eq 'password') { $validation->optional('password') }
    elsif ($k eq 'username') { $validation->optional('username') }
    elsif ($k eq 'login')    { $validation->required('login')->size(3, 30) }
    elsif ($k eq 'name')     { $validation->required('name')->like(qr{^[-a-z0-9]+$}) }    # network name
    elsif ($k eq 'nick')     { $validation->required('nick')->size(1, 30) }
    elsif ($k eq 'server') { $validation->required('server')->like($Convos::Core::Util::SERVER_NAME_RE) }
    else                   { $validation->required($k) }
  }

  $validation;
}

sub DESTROY {
  my $self = shift;
  delete $self->{$_} for qw/ control redis /;
}

=head1 COPYRIGHT

See L<Convos>.

=head1 AUTHOR

Jan Henning Thorsen

Marcus Ramberg

=cut

1;
