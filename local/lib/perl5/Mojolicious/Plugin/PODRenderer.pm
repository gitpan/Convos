package Mojolicious::Plugin::PODRenderer;
use Mojo::Base 'Mojolicious::Plugin';

use Mojo::Asset::File;
use Mojo::ByteStream 'b';
use Mojo::DOM;
use Mojo::URL;
use Mojo::Util qw(slurp unindent url_escape);
use Pod::Simple::HTML;
use Pod::Simple::Search;

sub register {
  my ($self, $app, $conf) = @_;

  my $preprocess = $conf->{preprocess} || 'ep';
  $app->renderer->add_handler(
    $conf->{name} || 'pod' => sub {
      my ($renderer, $c, $output, $options) = @_;

      # Preprocess and render
      my $handler = $renderer->handlers->{$preprocess};
      return undef unless $handler->($renderer, $c, $output, $options);
      $$output = _pod_to_html($$output);
      return 1;
    }
  );

  $app->helper(pod_to_html => sub { shift; b(_pod_to_html(@_)) });

  # Perldoc browser
  return undef if $conf->{no_perldoc};
  my $defaults = {module => 'Mojolicious/Guides', format => 'html'};
  return $app->routes->any(
    '/perldoc/:module' => $defaults => [module => qr/[^.]+/] => \&_perldoc);
}

sub _html {
  my ($self, $src) = @_;

  # Rewrite links
  my $dom     = Mojo::DOM->new(_pod_to_html($src));
  my $perldoc = $self->url_for('/perldoc/');
  for my $e ($dom->find('a[href]')->each) {
    my $attrs = $e->attr;
    $attrs->{href} =~ s!%3A%3A!/!gi
      if $attrs->{href} =~ s!^http://search\.cpan\.org/perldoc\?!$perldoc!;
  }

  # Rewrite code blocks for syntax highlighting and correct indentation
  for my $e ($dom->find('pre')->each) {
    $e->content(my $str = unindent $e->content);
    next if $str =~ /^\s*(?:\$|Usage:)\s+/m || $str !~ /[\$\@\%]\w|-&gt;\w/m;
    my $attrs = $e->attr;
    my $class = $attrs->{class};
    $attrs->{class} = defined $class ? "$class prettyprint" : 'prettyprint';
  }

  # Rewrite headers
  my $toc = Mojo::URL->new->fragment('toc');
  my (%anchors, @parts);
  for my $e ($dom->find('h1, h2, h3')->each) {

    # Anchor and text
    my $name = my $text = $e->all_text;
    $name =~ s/\s+/_/g;
    $name =~ s/[^\w\-]//g;
    my $anchor = $name;
    my $i      = 1;
    $anchor = $name . $i++ while $anchors{$anchor}++;

    # Rewrite
    push @parts, [] if $e->type eq 'h1' || !@parts;
    push @{$parts[-1]}, $text, Mojo::URL->new->fragment($anchor);
    $e->content($self->link_to($text => $toc, id => $anchor));
  }

  # Try to find a title
  my $title = 'Perldoc';
  $dom->find('h1 + p')->first(sub { $title = shift->text });

  # Combine everything to a proper response
  $self->content_for(perldoc => "$dom");
  my $template = $self->app->renderer->_bundled('perldoc');
  $self->render(inline => $template, title => $title, parts => \@parts);
}

sub _perldoc {
  my $self = shift;

  # Find module or redirect to CPAN
  my $module = $self->param('module');
  $module =~ s!/!::!g;
  my $path
    = Pod::Simple::Search->new->find($module, map { $_, "$_/pods" } @INC);
  return $self->redirect_to("http://metacpan.org/module/$module")
    unless $path && -r $path;

  my $src = slurp $path;
  $self->respond_to(txt => {data => $src}, html => sub { _html($self, $src) });
}

sub _pod_to_html {
  return '' unless defined(my $pod = shift);

  # Block
  $pod = $pod->() if ref $pod eq 'CODE';

  my $parser = Pod::Simple::HTML->new;
  $parser->force_title('');
  $parser->html_header_before_title('');
  $parser->html_header_after_title('');
  $parser->html_footer('');
  $parser->output_string(\(my $output));
  return $@ unless eval { $parser->parse_string_document("$pod"); 1 };

  # Filter
  $output =~ s!<a name='___top' class='dummyTopAnchor'\s*?></a>\n!!g;
  $output =~ s!<a class='u'.*?name=".*?"\s*>(.*?)</a>!$1!sg;

  return $output;
}

1;

=encoding utf8

=head1 NAME

Mojolicious::Plugin::PODRenderer - POD renderer plugin

=head1 SYNOPSIS

  # Mojolicious
  my $route = $self->plugin('PODRenderer');
  my $route = $self->plugin(PODRenderer => {name => 'foo'});
  my $route = $self->plugin(PODRenderer => {preprocess => 'epl'});

  # Mojolicious::Lite
  my $route = plugin 'PODRenderer';
  my $route = plugin PODRenderer => {name => 'foo'};
  my $route = plugin PODRenderer => {preprocess => 'epl'};

  # foo.html.ep
  %= pod_to_html "=head1 TEST\n\nC<123>"

=head1 DESCRIPTION

L<Mojolicious::Plugin::PODRenderer> is a renderer for true Perl hackers, rawr!

The code of this plugin is a good example for learning to build new plugins,
you're welcome to fork it.

See L<Mojolicious::Plugins/"PLUGINS"> for a list of plugins that are available
by default.

=head1 OPTIONS

L<Mojolicious::Plugin::PODRenderer> supports the following options.

=head2 name

  # Mojolicious::Lite
  plugin PODRenderer => {name => 'foo'};

Handler name, defaults to C<pod>.

=head2 no_perldoc

  # Mojolicious::Lite
  plugin PODRenderer => {no_perldoc => 1};

Disable L<Mojolicious::Guides> documentation browser that will otherwise be
available under C</perldoc>.

=head2 preprocess

  # Mojolicious::Lite
  plugin PODRenderer => {preprocess => 'epl'};

Name of handler used to preprocess POD, defaults to C<ep>.

=head1 HELPERS

L<Mojolicious::Plugin::PODRenderer> implements the following helpers.

=head2 pod_to_html

  %= pod_to_html '=head2 lalala'
  <%= pod_to_html begin %>=head2 lalala<% end %>

Render POD to HTML without preprocessing.

=head1 METHODS

L<Mojolicious::Plugin::PODRenderer> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  my $route = $plugin->register(Mojolicious->new);
  my $route = $plugin->register(Mojolicious->new, {name => 'foo'});

Register renderer and helper in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
