use ExtUtils::MakeMaker;
WriteMakefile(
  NAME => 'Convos',
  ABSTRACT_FROM => 'lib/Convos.pm',
  VERSION_FROM => 'lib/Convos.pm',
  AUTHOR => 'Jan Henning Thorsen <jhthorsen@cpan.org>',
  LICENSE => 'artistic_2',
  PREREQ_PM => {},
  BUILD_REQUIRES => {
    'IRC::Utils' => '0.12',
    'Mojo::IRC' => '0.0303',
    'Mojo::Redis' => '0.992',
    'Mojolicious' => '4.6',
    'Mojolicious::Plugin::AssetPack' => '0.0502',
    'Parse::IRC' => '1.18',
    'Time::Piece' => '1.2',
    'Unicode::UTF8' => '0.58'
  },
  META_MERGE => {
    resources => {
      license => 'http://www.opensource.org/licenses/artistic-license-2.0',
      homepage => 'https://github.com/Nordaaker/convos',
      bugtracker => 'https://github.com/Nordaaker/convos/issues',
      repository => 'https://github.com/Nordaaker/convos',
    },
  },
  test => { TESTS => 't/*.t' },
  EXE_FILES => ['script/convos'],
);
