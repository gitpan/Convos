package Convos::Connection;

=head1 NAME

Convos::Connection - Mojolicious controller for IRC connections

=cut

use Mojo::Base 'Mojolicious::Controller';
use Convos::Core::Util qw( as_id id_as );

=head1 METHODS

=head2 add_connection

Add a new connection based on network name.

=cut

sub add_connection {
  my $self      = shift->render_later;
  my $full_page = $self->stash('full_page');
  my $method    = $self->req->method eq 'POST' ? '_add_connection' : '_add_connection_form';

  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;

      $self->connection_list($delay->begin);
      $self->conversation_list($delay->begin) if $full_page;
      $self->notification_list($delay->begin) if $full_page;
      $delay->begin->();
    },
    sub {
      my ($delay) = @_;
      $self->$method;
    },
  );
}

=head2 add_network

Add a new network.

NOTE: This method currently also does update.

=cut

sub add_network {
  my $self       = shift->render_later;
  my $validation = $self->validation;
  my @channels   = map { split /\s+/ } $self->param('channels');
  my ($is_default, $name, $redis, $referrer);

  $self->stash(layout => 'tactile', channels => \@channels);
  $self->req->method eq 'POST' or return $self->render;

  $validation->input->{tls}      ||= 0;
  $validation->input->{password} ||= 0;
  $validation->required('name')->like(qr{^[-a-z0-9]+$});
  $validation->required('server')->like(qr{^[-a-z0-9_\.]+(:\d+)?$});
  $validation->required('password')->in(0, 1);
  $validation->required('tls')->in(0, 1);
  $validation->optional('home_page')->like(qr{^https?://.});
  $validation->has_error and return $self->render(status => 400);
  $validation->output->{channels} = join ' ', @channels;

  if ($validation->output->{server} =~ s!:(\d+)!!) {
    $validation->output->{port} = $1;
  }
  else {
    $validation->output->{port} = $validation->input->{tls} ? 6697 : 6667;
  }

  $redis      = $self->redis;
  $name       = delete $validation->output->{name};
  $is_default = $self->param('default') || 0;
  $referrer   = $self->param('referrer') || '/';

  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;

      $redis->set("irc:default:network", $name, $delay->begin) if $is_default;
      $redis->sadd("irc:networks", $name, $delay->begin);
      $redis->hmset("irc:network:$name", $validation->output, $delay->begin);
    },
    sub {
      my ($delay, @success) = @_;
      $self->redirect_to($referrer);
    },
  );
}

=head2 control

  POST /:name/control/start
  POST /:name/control/stop
  POST /:name/control/restart
  GET /:name/control/state

Used to control a connection. See L<Convos::Core/control>.

Special case is "state": It will return the state of the connection:
"disconnected", "error", "reconnecting" or "connected".

=cut

sub control {
  my $self        = shift->render_later;
  my $command     = $self->param('cmd') || 'state';
  my $name        = $self->stash('name');
  my $redirect_to = $self->url_for('view.network', {network => $name});

  $self->stash(layout => undef);

  if ($command eq 'state') {
    return $self->_connection_state(
      sub {
        $self->respond_to(json => {json => {state => $_[1]}}, any => {text => "$_[1]\n"},);
      }
    );
  }

  if ($self->req->method ne 'POST') {
    return $self->_invalid_control_request;
  }

  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;
      $self->app->core->control($command, $self->session('login'), $name, $delay->begin);
    },
    sub {
      my ($delay, $sent) = @_;
      my $status = $sent ? 200 : 500;
      my $state = $command eq 'stop' ? 'stopping' : "${command}ing";

      $self->respond_to(
        json => {json => {state => $state}, status => $status},
        any  => sub   { shift->redirect_to($redirect_to) },
      );
    },
  );
}

=head2 edit_connection

Used to edit a connection.

=cut

sub edit_connection {
  my $self      = shift->render_later;
  my $full_page = $self->stash('full_page');
  my $method    = $self->req->method eq 'POST' ? '_edit_connection' : '_edit_connection_form';

  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;

      if ($full_page) {
        $self->_connection_state($delay->begin);
        $self->conversation_list($delay->begin);
        $self->notification_list($delay->begin);
      }

      $self->connection_list($delay->begin);
    },
    sub {
      my ($delay, $state) = @_;

      $self->stash(network => $self->stash('name'), state => $state,);

      $self->$method;
    },
  );
}

=head2 edit_network

Used to edit settings for a network.

=cut

sub edit_network {
  my $self = shift->render_later;
  my $name = $self->stash('name');

  $self->stash(layout => 'tactile');

  if ($self->req->method eq 'POST') {
    $self->param(referrer => $self->req->url->to_abs);
    $self->validation->input->{name} = $name;
    $self->add_network;
    return;
  }

  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;

      $self->redis->execute([get => 'irc:default:network'], [hgetall => "irc:network:$name"], $delay->begin);
    },
    sub {
      my ($delay, $default_network, $network) = @_;

      $network->{server} or return $self->render_not_found;
      $self->param($_ => $network->{$_} || '') for qw( channels password tls home_page );
      $self->param(name    => $name);
      $self->param(default => 1) if $default_network eq $name;
      $self->param(server  => join ':', @$network{qw( server port )});
      $self->render(default_network => $default_network, name => $name, network => $network,);
    },
  );
}

=head2 delete_connection

Delete a connection.

=cut

sub delete_connection {
  my $self       = shift->render_later;
  my $validation = $self->validation;

  $validation->input->{login} = $self->session('login');
  $validation->input->{name}  = $self->stash('name');

  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;
      $self->app->core->delete_connection($validation, $delay->begin);
    },
    sub {
      my ($delay, $error) = @_;
      return $self->render_not_found if $error;
      return $self->redirect_to('view.network', network => 'convos');
    }
  );
}

=head2 wizard

Render wizard page for first connection.

=cut

sub wizard {
  my $self = shift->render_later;

  $self->stash(layout => 'tactile', template => 'connection/wizard',);

  $self->_add_connection_form;
}

sub _add_connection {
  my $self       = shift;
  my $validation = $self->validation;
  my $name       = $self->param('name') || '';

  $validation->input->{channels} = [map { split /\s/ } $self->param('channels')];
  $validation->input->{login} = $self->session('login');

  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;
      $self->redis->hgetall("irc:network:$name", $delay->begin);
    },
    sub {
      my ($delay, $params) = @_;

      $validation->input->{$_} ||= $params->{$_} for keys %$params;
      $self->app->core->add_connection($validation, $delay->begin);
    },
    sub {
      my ($delay, $errors, $conn) = @_;

      return $self->redirect_to('view.network', network => 'convos') unless $errors;
      return $self->param('wizard') ? $self->wizard : $self->_add_connection_form;
    },
  );
}

sub _add_connection_form {
  my $self  = shift;
  my $login = $self->session('login');
  my $redis = $self->redis;

  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;
      $redis->smembers("user:$login:connections", $delay->begin);
      $redis->smembers("irc:networks",            $delay->begin);
    },
    sub {
      my $delay    = shift;
      my %existing = map { $_, 1 } sort @{shift || []};
      my @names    = sort grep { !$existing{$_} } @{shift || []};

      unless (@names) {
        return $self->render(default_network => '', networks => []);
      }

      $delay->begin(0)->(\@names);
      $redis->get('irc:default:network', $delay->begin);
      $redis->hgetall("irc:network:$_", $delay->begin) for @names;
    },
    sub {
      my ($delay, $names, $default_network, @networks) = @_;
      my $channels = $self->param('channels');

      for my $network (@networks) {
        $network->{name} = shift @$names;
        $channels = $network->{channels} || '' if !$channels and $network->{name} eq $default_network;
      }

      $self->param(channels => $channels || $networks[0]{channels} || '');
      $self->render(default_network => $default_network, networks => \@networks,);
    },
  );
}

sub _connection_state {
  my ($self, $cb) = @_;
  my $login = $self->session('login');
  my $name  = $self->stash('name');

  $self->redis->hget("user:$login:connection:$name" => "state", sub { $cb->($_[0], $_[1] || 'disconnected') },);
}

sub _edit_connection {
  my $self       = shift;
  my $validation = $self->validation;
  my $full_page  = $self->stash('full_page');

  $validation->input->{channels} = [map { split /\s+/ } $self->param('channels')];
  $validation->input->{login}    = $self->session('login');
  $validation->input->{name}     = $self->stash('name');
  $validation->input->{server}   = $self->req->body_params->param('server');
  $validation->input->{tls} ||= 0;

  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;
      $self->app->core->update_connection($validation, $delay->begin);
    },
    sub {
      my ($delay, $errors, $changed) = @_;
      return $self->_edit_connection_form if $errors;
      return $self->redirect_to('view.network', network => $self->stash('name'));
    }
  );
}

sub _edit_connection_form {
  my $self  = shift;
  my $login = $self->session('login');
  my $name  = $self->stash('name');

  Mojo::IOLoop->delay(
    sub {
      my ($delay) = @_;
      $self->_connection_state($delay->begin);
      $self->redis->hgetall("user:$login:connection:$name", $delay->begin) unless $self->req->method eq 'POST';
    },
    sub {
      my ($delay, $state, $connection) = @_;
      $self->param($_ => $connection->{$_}) for keys %$connection;
      $self->render(state => $state);
    },
  );
}

sub _invalid_control_request {
  shift->respond_to(json => {json => {}, status => 400}, any => {text => "Invalid request\n", status => 400},);
}

=head1 COPYRIGHT

See L<Convos>.

=head1 AUTHOR

Jan Henning Thorsen

Marcus Ramberg

=cut

1;
