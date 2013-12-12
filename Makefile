# This Makefile is for the Convos extension to perl.
#
# It was generated automatically by MakeMaker version
# 6.66 (Revision: 66600) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#       ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker ARGV: ()
#

#   MakeMaker Parameters:

#     ABSTRACT_FROM => q[lib/Convos.pm]
#     AUTHOR => [q[Jan Henning Thorsen <jhthorsen@cpan.org>]]
#     BUILD_REQUIRES => { Mojolicious=>q[4.6], Mojolicious::Plugin::AssetPack=>q[0.0502], Mojo::IRC=>q[0.0303], Mojo::Redis=>q[0.992], Unicode::UTF8=>q[0.58], Parse::IRC=>q[1.18], Time::Piece=>q[1.2], IRC::Utils=>q[0.12] }
#     CONFIGURE_REQUIRES => {  }
#     EXE_FILES => [q[script/convos]]
#     LICENSE => q[artistic_2]
#     META_MERGE => { resources=>{ license=>q[http://www.opensource.org/licenses/artistic-license-2.0], bugtracker=>q[https://github.com/Nordaaker/convos/issues], homepage=>q[https://github.com/Nordaaker/convos], repository=>q[https://github.com/Nordaaker/convos] } }
#     NAME => q[Convos]
#     PREREQ_PM => { Parse::IRC=>q[1.18], Unicode::UTF8=>q[0.58], Mojo::Redis=>q[0.992], Mojo::IRC=>q[0.0303], Mojolicious::Plugin::AssetPack=>q[0.0502], Time::Piece=>q[1.2], IRC::Utils=>q[0.12], Mojolicious=>q[4.6] }
#     TEST_REQUIRES => {  }
#     VERSION_FROM => q[lib/Convos.pm]
#     test => { TESTS=>q[t/*.t] }

# --- MakeMaker post_initialize section:


# --- MakeMaker const_config section:

# These definitions are from config.sh (via /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/lib/5.18.1/x86_64-linux/Config.pm).
# They may have been overridden via Makefile.PL or on the command line.
AR = ar
CC = cc
CCCDLFLAGS = -fPIC
CCDLFLAGS = -Wl,-E
DLEXT = so
DLSRC = dl_dlopen.xs
EXE_EXT = 
FULL_AR = /usr/bin/ar
LD = cc
LDDLFLAGS = -shared -O2 -L/usr/local/lib -fstack-protector
LDFLAGS =  -fstack-protector -L/usr/local/lib
LIBC = 
LIB_EXT = .a
OBJ_EXT = .o
OSNAME = linux
OSVERS = 3.11.0-14-generic
RANLIB = :
SITELIBEXP = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/lib/site_perl/5.18.1
SITEARCHEXP = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/lib/site_perl/5.18.1/x86_64-linux
SO = so
VENDORARCHEXP = 
VENDORLIBEXP = 


# --- MakeMaker constants section:
AR_STATIC_ARGS = cr
DIRFILESEP = /
DFSEP = $(DIRFILESEP)
NAME = Convos
NAME_SYM = Convos
VERSION = 0.1001
VERSION_MACRO = VERSION
VERSION_SYM = 0_1001
DEFINE_VERSION = -D$(VERSION_MACRO)=\"$(VERSION)\"
XS_VERSION = 0.1001
XS_VERSION_MACRO = XS_VERSION
XS_DEFINE_VERSION = -D$(XS_VERSION_MACRO)=\"$(XS_VERSION)\"
INST_ARCHLIB = blib/arch
INST_SCRIPT = blib/script
INST_BIN = blib/bin
INST_LIB = blib/lib
INST_MAN1DIR = blib/man1
INST_MAN3DIR = blib/man3
MAN1EXT = 1
MAN3EXT = 3
INSTALLDIRS = site
DESTDIR = 
PREFIX = $(SITEPREFIX)
PERLPREFIX = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1
SITEPREFIX = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1
VENDORPREFIX = 
INSTALLPRIVLIB = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/lib/5.18.1
DESTINSTALLPRIVLIB = $(DESTDIR)$(INSTALLPRIVLIB)
INSTALLSITELIB = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/lib/site_perl/5.18.1
DESTINSTALLSITELIB = $(DESTDIR)$(INSTALLSITELIB)
INSTALLVENDORLIB = 
DESTINSTALLVENDORLIB = $(DESTDIR)$(INSTALLVENDORLIB)
INSTALLARCHLIB = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/lib/5.18.1/x86_64-linux
DESTINSTALLARCHLIB = $(DESTDIR)$(INSTALLARCHLIB)
INSTALLSITEARCH = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/lib/site_perl/5.18.1/x86_64-linux
DESTINSTALLSITEARCH = $(DESTDIR)$(INSTALLSITEARCH)
INSTALLVENDORARCH = 
DESTINSTALLVENDORARCH = $(DESTDIR)$(INSTALLVENDORARCH)
INSTALLBIN = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/bin
DESTINSTALLBIN = $(DESTDIR)$(INSTALLBIN)
INSTALLSITEBIN = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/bin
DESTINSTALLSITEBIN = $(DESTDIR)$(INSTALLSITEBIN)
INSTALLVENDORBIN = 
DESTINSTALLVENDORBIN = $(DESTDIR)$(INSTALLVENDORBIN)
INSTALLSCRIPT = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/bin
DESTINSTALLSCRIPT = $(DESTDIR)$(INSTALLSCRIPT)
INSTALLSITESCRIPT = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/bin
DESTINSTALLSITESCRIPT = $(DESTDIR)$(INSTALLSITESCRIPT)
INSTALLVENDORSCRIPT = 
DESTINSTALLVENDORSCRIPT = $(DESTDIR)$(INSTALLVENDORSCRIPT)
INSTALLMAN1DIR = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/man/man1
DESTINSTALLMAN1DIR = $(DESTDIR)$(INSTALLMAN1DIR)
INSTALLSITEMAN1DIR = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/man/man1
DESTINSTALLSITEMAN1DIR = $(DESTDIR)$(INSTALLSITEMAN1DIR)
INSTALLVENDORMAN1DIR = 
DESTINSTALLVENDORMAN1DIR = $(DESTDIR)$(INSTALLVENDORMAN1DIR)
INSTALLMAN3DIR = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/man/man3
DESTINSTALLMAN3DIR = $(DESTDIR)$(INSTALLMAN3DIR)
INSTALLSITEMAN3DIR = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/man/man3
DESTINSTALLSITEMAN3DIR = $(DESTDIR)$(INSTALLSITEMAN3DIR)
INSTALLVENDORMAN3DIR = 
DESTINSTALLVENDORMAN3DIR = $(DESTDIR)$(INSTALLVENDORMAN3DIR)
PERL_LIB = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/lib/5.18.1
PERL_ARCHLIB = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/lib/5.18.1/x86_64-linux
LIBPERL_A = libperl.a
FIRST_MAKEFILE = Makefile
MAKEFILE_OLD = Makefile.old
MAKE_APERL_FILE = Makefile.aperl
PERLMAINCC = $(CC)
PERL_INC = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/lib/5.18.1/x86_64-linux/CORE
PERL = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/bin/perl
FULLPERL = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/bin/perl
ABSPERL = $(PERL)
PERLRUN = $(PERL)
FULLPERLRUN = $(FULLPERL)
ABSPERLRUN = $(ABSPERL)
PERLRUNINST = $(PERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
FULLPERLRUNINST = $(FULLPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
ABSPERLRUNINST = $(ABSPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
PERL_CORE = 0
PERM_DIR = 755
PERM_RW = 644
PERM_RWX = 755

MAKEMAKER   = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/lib/5.18.1/ExtUtils/MakeMaker.pm
MM_VERSION  = 6.66
MM_REVISION = 66600

# FULLEXT = Pathname for extension directory (eg Foo/Bar/Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT. (eg Oracle)
# PARENT_NAME = NAME without BASEEXT and no trailing :: (eg Foo::Bar)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
MAKE = make
FULLEXT = Convos
BASEEXT = Convos
PARENT_NAME = 
DLBASE = $(BASEEXT)
VERSION_FROM = lib/Convos.pm
OBJECT = 
LDFROM = $(OBJECT)
LINKTYPE = dynamic
BOOTDEP = 

# Handy lists of source code files:
XS_FILES = 
C_FILES  = 
O_FILES  = 
H_FILES  = 
MAN1PODS = 
MAN3PODS = lib/Convos.pm \
	lib/Convos/Archive.pm \
	lib/Convos/Chat.pm \
	lib/Convos/Client.pm \
	lib/Convos/Command/backend.pm \
	lib/Convos/Core.pm \
	lib/Convos/Core/Archive.pm \
	lib/Convos/Core/Commands.pm \
	lib/Convos/Core/Connection.pm \
	lib/Convos/Core/Util.pm \
	lib/Convos/Loopback.pm \
	lib/Convos/Oembed.pm \
	lib/Convos/Plugin/Helpers.pm \
	lib/Convos/User.pm

# Where is the Config information that we are using/depend on
CONFIGDEP = $(PERL_ARCHLIB)$(DFSEP)Config.pm $(PERL_INC)$(DFSEP)config.h

# Where to build things
INST_LIBDIR      = $(INST_LIB)
INST_ARCHLIBDIR  = $(INST_ARCHLIB)

INST_AUTODIR     = $(INST_LIB)/auto/$(FULLEXT)
INST_ARCHAUTODIR = $(INST_ARCHLIB)/auto/$(FULLEXT)

INST_STATIC      = 
INST_DYNAMIC     = 
INST_BOOT        = 

# Extra linker info
EXPORT_LIST        = 
PERL_ARCHIVE       = 
PERL_ARCHIVE_AFTER = 


TO_INST_PM = lib/Convos.pm \
	lib/Convos/Archive.pm \
	lib/Convos/Chat.pm \
	lib/Convos/Client.pm \
	lib/Convos/Command/backend.pm \
	lib/Convos/Core.pm \
	lib/Convos/Core/Archive.pm \
	lib/Convos/Core/Commands.pm \
	lib/Convos/Core/Connection.pm \
	lib/Convos/Core/Util.pm \
	lib/Convos/Loopback.pm \
	lib/Convos/Oembed.pm \
	lib/Convos/Plugin/Helpers.pm \
	lib/Convos/User.pm \
	lib/Convos/convos.conf \
	lib/Convos/public/convos.manifest \
	lib/Convos/public/favicon.ico \
	lib/Convos/public/font/fontawesome-webfont.afm \
	lib/Convos/public/font/fontawesome-webfont.eot \
	lib/Convos/public/font/fontawesome-webfont.ttf \
	lib/Convos/public/font/fontawesome-webfont.woff \
	lib/Convos/public/image/help.png \
	lib/Convos/public/image/icon-128.png \
	lib/Convos/public/image/icon-196.png \
	lib/Convos/public/image/landing-page-example-chat.jpeg \
	lib/Convos/public/image/loader-facebook.gif \
	lib/Convos/public/image/loader-squares-circle.gif \
	lib/Convos/public/image/logo.png \
	lib/Convos/public/image/logo.svg \
	lib/Convos/public/js/convos.chat.js \
	lib/Convos/public/js/globals.js \
	lib/Convos/public/js/jquery.doubletap.js \
	lib/Convos/public/js/jquery.fastbutton.js \
	lib/Convos/public/js/jquery.fastbutton.min.js \
	lib/Convos/public/js/jquery.helpers.js \
	lib/Convos/public/js/jquery.hotkeys.js \
	lib/Convos/public/js/jquery.hotkeys.min.js \
	lib/Convos/public/js/jquery.min.js \
	lib/Convos/public/js/jquery.nanoscroller.min.js \
	lib/Convos/public/js/jquery.pjax.js \
	lib/Convos/public/js/jquery.pjax.min.js \
	lib/Convos/public/js/selectize.min.js \
	lib/Convos/public/js/ws-reconnecting.js \
	lib/Convos/public/packed/convos-24520b065f62fbe702d11648f8a1c02f.css \
	lib/Convos/public/packed/convos-671e8d97976e1dbcfbd351eeac7cb5bf.js \
	lib/Convos/public/packed/main-24520b065f62fbe702d11648f8a1c02f.css \
	lib/Convos/public/sass/.sass-cache/49c3749e8d67888e6efa4aaa046500d4537c7173/selectize.scssc \
	lib/Convos/public/sass/.sass-cache/a951694f82d90dd3c3e0af05ea817ae5f104c7b7/selectize.scssc \
	lib/Convos/public/sass/main.scss \
	lib/Convos/public/sass/selectize.scss \
	lib/Convos/templates/client/conversation.html.ep \
	lib/Convos/templates/client/conversation_list.html.ep \
	lib/Convos/templates/client/notification_list.html.ep \
	lib/Convos/templates/client/view.html.ep \
	lib/Convos/templates/empty.html.ep \
	lib/Convos/templates/event/action_message.html.ep \
	lib/Convos/templates/event/add_conversation.html.ep \
	lib/Convos/templates/event/channel_list.html.ep \
	lib/Convos/templates/event/connection.html.ep \
	lib/Convos/templates/event/help.html.ep \
	lib/Convos/templates/event/historic_messages.html.ep \
	lib/Convos/templates/event/message.html.ep \
	lib/Convos/templates/event/mode.html.ep \
	lib/Convos/templates/event/nick_change.html.ep \
	lib/Convos/templates/event/nick_joined.html.ep \
	lib/Convos/templates/event/nick_parted.html.ep \
	lib/Convos/templates/event/nick_quit.html.ep \
	lib/Convos/templates/event/remove_conversation.html.ep \
	lib/Convos/templates/event/rpl_namreply.html.ep \
	lib/Convos/templates/event/server_message.html.ep \
	lib/Convos/templates/event/topic.html.ep \
	lib/Convos/templates/event/topic_by.html.ep \
	lib/Convos/templates/event/user.html.ep \
	lib/Convos/templates/event/welcome.html.ep \
	lib/Convos/templates/event/whois.html.ep \
	lib/Convos/templates/event/whois_channels.html.ep \
	lib/Convos/templates/inc/alert.html.ep \
	lib/Convos/templates/index.html.ep \
	lib/Convos/templates/layouts/default.html.ep \
	lib/Convos/templates/not_found.production.html.ep \
	lib/Convos/templates/oembed/image.html.ep \
	lib/Convos/templates/oembed/youtube.html.ep \
	lib/Convos/templates/user/invite_only.html.ep \
	lib/Convos/templates/user/login.html.ep \
	lib/Convos/templates/user/register.html.ep

PM_TO_BLIB = lib/Convos/templates/event/welcome.html.ep \
	blib/lib/Convos/templates/event/welcome.html.ep \
	lib/Convos/templates/event/topic.html.ep \
	blib/lib/Convos/templates/event/topic.html.ep \
	lib/Convos/public/font/fontawesome-webfont.woff \
	blib/lib/Convos/public/font/fontawesome-webfont.woff \
	lib/Convos/public/image/logo.png \
	blib/lib/Convos/public/image/logo.png \
	lib/Convos/templates/event/rpl_namreply.html.ep \
	blib/lib/Convos/templates/event/rpl_namreply.html.ep \
	lib/Convos/public/sass/main.scss \
	blib/lib/Convos/public/sass/main.scss \
	lib/Convos/Chat.pm \
	blib/lib/Convos/Chat.pm \
	lib/Convos/Archive.pm \
	blib/lib/Convos/Archive.pm \
	lib/Convos/public/packed/convos-24520b065f62fbe702d11648f8a1c02f.css \
	blib/lib/Convos/public/packed/convos-24520b065f62fbe702d11648f8a1c02f.css \
	lib/Convos/templates/event/connection.html.ep \
	blib/lib/Convos/templates/event/connection.html.ep \
	lib/Convos/public/image/icon-196.png \
	blib/lib/Convos/public/image/icon-196.png \
	lib/Convos/public/font/fontawesome-webfont.afm \
	blib/lib/Convos/public/font/fontawesome-webfont.afm \
	lib/Convos/public/sass/.sass-cache/49c3749e8d67888e6efa4aaa046500d4537c7173/selectize.scssc \
	blib/lib/Convos/public/sass/.sass-cache/49c3749e8d67888e6efa4aaa046500d4537c7173/selectize.scssc \
	lib/Convos/public/js/jquery.helpers.js \
	blib/lib/Convos/public/js/jquery.helpers.js \
	lib/Convos/Oembed.pm \
	blib/lib/Convos/Oembed.pm \
	lib/Convos/public/js/globals.js \
	blib/lib/Convos/public/js/globals.js \
	lib/Convos/Core/Connection.pm \
	blib/lib/Convos/Core/Connection.pm \
	lib/Convos/templates/oembed/image.html.ep \
	blib/lib/Convos/templates/oembed/image.html.ep \
	lib/Convos/templates/event/whois_channels.html.ep \
	blib/lib/Convos/templates/event/whois_channels.html.ep \
	lib/Convos/public/js/jquery.hotkeys.min.js \
	blib/lib/Convos/public/js/jquery.hotkeys.min.js \
	lib/Convos/public/image/landing-page-example-chat.jpeg \
	blib/lib/Convos/public/image/landing-page-example-chat.jpeg \
	lib/Convos/templates/client/view.html.ep \
	blib/lib/Convos/templates/client/view.html.ep \
	lib/Convos/Loopback.pm \
	blib/lib/Convos/Loopback.pm \
	lib/Convos/public/js/jquery.min.js \
	blib/lib/Convos/public/js/jquery.min.js \
	lib/Convos/convos.conf \
	blib/lib/Convos/convos.conf \
	lib/Convos.pm \
	blib/lib/Convos.pm \
	lib/Convos/templates/event/historic_messages.html.ep \
	blib/lib/Convos/templates/event/historic_messages.html.ep \
	lib/Convos/templates/client/notification_list.html.ep \
	blib/lib/Convos/templates/client/notification_list.html.ep \
	lib/Convos/templates/index.html.ep \
	blib/lib/Convos/templates/index.html.ep \
	lib/Convos/templates/user/login.html.ep \
	blib/lib/Convos/templates/user/login.html.ep \
	lib/Convos/templates/event/nick_parted.html.ep \
	blib/lib/Convos/templates/event/nick_parted.html.ep \
	lib/Convos/public/convos.manifest \
	blib/lib/Convos/public/convos.manifest \
	lib/Convos/public/js/jquery.fastbutton.min.js \
	blib/lib/Convos/public/js/jquery.fastbutton.min.js \
	lib/Convos/public/image/help.png \
	blib/lib/Convos/public/image/help.png \
	lib/Convos/templates/event/mode.html.ep \
	blib/lib/Convos/templates/event/mode.html.ep \
	lib/Convos/Client.pm \
	blib/lib/Convos/Client.pm \
	lib/Convos/templates/inc/alert.html.ep \
	blib/lib/Convos/templates/inc/alert.html.ep \
	lib/Convos/public/sass/.sass-cache/a951694f82d90dd3c3e0af05ea817ae5f104c7b7/selectize.scssc \
	blib/lib/Convos/public/sass/.sass-cache/a951694f82d90dd3c3e0af05ea817ae5f104c7b7/selectize.scssc \
	lib/Convos/public/js/ws-reconnecting.js \
	blib/lib/Convos/public/js/ws-reconnecting.js \
	lib/Convos/Command/backend.pm \
	blib/lib/Convos/Command/backend.pm \
	lib/Convos/templates/event/whois.html.ep \
	blib/lib/Convos/templates/event/whois.html.ep \
	lib/Convos/templates/event/nick_quit.html.ep \
	blib/lib/Convos/templates/event/nick_quit.html.ep \
	lib/Convos/public/js/jquery.nanoscroller.min.js \
	blib/lib/Convos/public/js/jquery.nanoscroller.min.js \
	lib/Convos/templates/event/server_message.html.ep \
	blib/lib/Convos/templates/event/server_message.html.ep \
	lib/Convos/Core.pm \
	blib/lib/Convos/Core.pm \
	lib/Convos/Core/Archive.pm \
	blib/lib/Convos/Core/Archive.pm \
	lib/Convos/public/js/jquery.pjax.min.js \
	blib/lib/Convos/public/js/jquery.pjax.min.js \
	lib/Convos/Core/Util.pm \
	blib/lib/Convos/Core/Util.pm \
	lib/Convos/public/js/jquery.pjax.js \
	blib/lib/Convos/public/js/jquery.pjax.js \
	lib/Convos/templates/event/action_message.html.ep \
	blib/lib/Convos/templates/event/action_message.html.ep \
	lib/Convos/public/js/convos.chat.js \
	blib/lib/Convos/public/js/convos.chat.js \
	lib/Convos/templates/event/message.html.ep \
	blib/lib/Convos/templates/event/message.html.ep \
	lib/Convos/User.pm \
	blib/lib/Convos/User.pm \
	lib/Convos/templates/user/register.html.ep \
	blib/lib/Convos/templates/user/register.html.ep \
	lib/Convos/templates/event/topic_by.html.ep \
	blib/lib/Convos/templates/event/topic_by.html.ep \
	lib/Convos/public/image/logo.svg \
	blib/lib/Convos/public/image/logo.svg \
	lib/Convos/public/sass/selectize.scss \
	blib/lib/Convos/public/sass/selectize.scss \
	lib/Convos/public/js/jquery.doubletap.js \
	blib/lib/Convos/public/js/jquery.doubletap.js \
	lib/Convos/public/packed/main-24520b065f62fbe702d11648f8a1c02f.css \
	blib/lib/Convos/public/packed/main-24520b065f62fbe702d11648f8a1c02f.css \
	lib/Convos/templates/event/remove_conversation.html.ep \
	blib/lib/Convos/templates/event/remove_conversation.html.ep \
	lib/Convos/public/js/jquery.fastbutton.js \
	blib/lib/Convos/public/js/jquery.fastbutton.js \
	lib/Convos/templates/not_found.production.html.ep \
	blib/lib/Convos/templates/not_found.production.html.ep \
	lib/Convos/public/js/selectize.min.js \
	blib/lib/Convos/public/js/selectize.min.js \
	lib/Convos/templates/client/conversation_list.html.ep \
	blib/lib/Convos/templates/client/conversation_list.html.ep \
	lib/Convos/public/font/fontawesome-webfont.ttf \
	blib/lib/Convos/public/font/fontawesome-webfont.ttf \
	lib/Convos/templates/client/conversation.html.ep \
	blib/lib/Convos/templates/client/conversation.html.ep \
	lib/Convos/templates/event/help.html.ep \
	blib/lib/Convos/templates/event/help.html.ep \
	lib/Convos/templates/event/add_conversation.html.ep \
	blib/lib/Convos/templates/event/add_conversation.html.ep \
	lib/Convos/public/image/loader-facebook.gif \
	blib/lib/Convos/public/image/loader-facebook.gif \
	lib/Convos/Core/Commands.pm \
	blib/lib/Convos/Core/Commands.pm \
	lib/Convos/templates/event/user.html.ep \
	blib/lib/Convos/templates/event/user.html.ep \
	lib/Convos/templates/user/invite_only.html.ep \
	blib/lib/Convos/templates/user/invite_only.html.ep \
	lib/Convos/templates/oembed/youtube.html.ep \
	blib/lib/Convos/templates/oembed/youtube.html.ep \
	lib/Convos/public/image/icon-128.png \
	blib/lib/Convos/public/image/icon-128.png \
	lib/Convos/templates/empty.html.ep \
	blib/lib/Convos/templates/empty.html.ep \
	lib/Convos/public/image/loader-squares-circle.gif \
	blib/lib/Convos/public/image/loader-squares-circle.gif \
	lib/Convos/templates/event/nick_change.html.ep \
	blib/lib/Convos/templates/event/nick_change.html.ep \
	lib/Convos/public/js/jquery.hotkeys.js \
	blib/lib/Convos/public/js/jquery.hotkeys.js \
	lib/Convos/public/packed/convos-671e8d97976e1dbcfbd351eeac7cb5bf.js \
	blib/lib/Convos/public/packed/convos-671e8d97976e1dbcfbd351eeac7cb5bf.js \
	lib/Convos/public/favicon.ico \
	blib/lib/Convos/public/favicon.ico \
	lib/Convos/templates/layouts/default.html.ep \
	blib/lib/Convos/templates/layouts/default.html.ep \
	lib/Convos/templates/event/nick_joined.html.ep \
	blib/lib/Convos/templates/event/nick_joined.html.ep \
	lib/Convos/public/font/fontawesome-webfont.eot \
	blib/lib/Convos/public/font/fontawesome-webfont.eot \
	lib/Convos/templates/event/channel_list.html.ep \
	blib/lib/Convos/templates/event/channel_list.html.ep \
	lib/Convos/Plugin/Helpers.pm \
	blib/lib/Convos/Plugin/Helpers.pm


# --- MakeMaker platform_constants section:
MM_Unix_VERSION = 6.66
PERL_MALLOC_DEF = -DPERL_EXTMALLOC_DEF -Dmalloc=Perl_malloc -Dfree=Perl_mfree -Drealloc=Perl_realloc -Dcalloc=Perl_calloc


# --- MakeMaker tool_autosplit section:
# Usage: $(AUTOSPLITFILE) FileToSplit AutoDirToSplitInto
AUTOSPLITFILE = $(ABSPERLRUN)  -e 'use AutoSplit;  autosplit($$$$ARGV[0], $$$$ARGV[1], 0, 1, 1)' --



# --- MakeMaker tool_xsubpp section:


# --- MakeMaker tools_other section:
SHELL = /bin/sh
CHMOD = chmod
CP = cp
MV = mv
NOOP = $(TRUE)
NOECHO = @
RM_F = rm -f
RM_RF = rm -rf
TEST_F = test -f
TOUCH = touch
UMASK_NULL = umask 0
DEV_NULL = > /dev/null 2>&1
MKPATH = $(ABSPERLRUN) -MExtUtils::Command -e 'mkpath' --
EQUALIZE_TIMESTAMP = $(ABSPERLRUN) -MExtUtils::Command -e 'eqtime' --
FALSE = false
TRUE = true
ECHO = echo
ECHO_N = echo -n
UNINST = 0
VERBINST = 0
MOD_INSTALL = $(ABSPERLRUN) -MExtUtils::Install -e 'install([ from_to => {@ARGV}, verbose => '\''$(VERBINST)'\'', uninstall_shadows => '\''$(UNINST)'\'', dir_mode => '\''$(PERM_DIR)'\'' ]);' --
DOC_INSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'perllocal_install' --
UNINSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'uninstall' --
WARN_IF_OLD_PACKLIST = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'warn_if_old_packlist' --
MACROSTART = 
MACROEND = 
USEMAKEFILE = -f
FIXIN = $(ABSPERLRUN) -MExtUtils::MY -e 'MY->fixin(shift)' --


# --- MakeMaker makemakerdflt section:
makemakerdflt : all
	$(NOECHO) $(NOOP)


# --- MakeMaker dist section:
TAR = tar
TARFLAGS = cvf
ZIP = zip
ZIPFLAGS = -r
COMPRESS = gzip --best
SUFFIX = .gz
SHAR = shar
PREOP = $(NOECHO) $(NOOP)
POSTOP = $(NOECHO) $(NOOP)
TO_UNIX = $(NOECHO) $(NOOP)
CI = ci -u
RCS_LABEL = rcs -Nv$(VERSION_SYM): -q
DIST_CP = best
DIST_DEFAULT = tardist
DISTNAME = Convos
DISTVNAME = Convos-0.1001


# --- MakeMaker macro section:


# --- MakeMaker depend section:


# --- MakeMaker cflags section:


# --- MakeMaker const_loadlibs section:


# --- MakeMaker const_cccmd section:


# --- MakeMaker post_constants section:


# --- MakeMaker pasthru section:

PASTHRU = LIBPERL_A="$(LIBPERL_A)"\
	LINKTYPE="$(LINKTYPE)"\
	PREFIX="$(PREFIX)"


# --- MakeMaker special_targets section:
.SUFFIXES : .xs .c .C .cpp .i .s .cxx .cc $(OBJ_EXT)

.PHONY: all config static dynamic test linkext manifest blibdirs clean realclean disttest distdir



# --- MakeMaker c_o section:


# --- MakeMaker xs_c section:


# --- MakeMaker xs_o section:


# --- MakeMaker top_targets section:
all :: pure_all manifypods
	$(NOECHO) $(NOOP)


pure_all :: config pm_to_blib subdirs linkext
	$(NOECHO) $(NOOP)

subdirs :: $(MYEXTLIB)
	$(NOECHO) $(NOOP)

config :: $(FIRST_MAKEFILE) blibdirs
	$(NOECHO) $(NOOP)

help :
	perldoc ExtUtils::MakeMaker


# --- MakeMaker blibdirs section:
blibdirs : $(INST_LIBDIR)$(DFSEP).exists $(INST_ARCHLIB)$(DFSEP).exists $(INST_AUTODIR)$(DFSEP).exists $(INST_ARCHAUTODIR)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists $(INST_SCRIPT)$(DFSEP).exists $(INST_MAN1DIR)$(DFSEP).exists $(INST_MAN3DIR)$(DFSEP).exists
	$(NOECHO) $(NOOP)

# Backwards compat with 6.18 through 6.25
blibdirs.ts : blibdirs
	$(NOECHO) $(NOOP)

$(INST_LIBDIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_LIBDIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_LIBDIR)
	$(NOECHO) $(TOUCH) $(INST_LIBDIR)$(DFSEP).exists

$(INST_ARCHLIB)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHLIB)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHLIB)
	$(NOECHO) $(TOUCH) $(INST_ARCHLIB)$(DFSEP).exists

$(INST_AUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_AUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_AUTODIR)
	$(NOECHO) $(TOUCH) $(INST_AUTODIR)$(DFSEP).exists

$(INST_ARCHAUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHAUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHAUTODIR)
	$(NOECHO) $(TOUCH) $(INST_ARCHAUTODIR)$(DFSEP).exists

$(INST_BIN)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_BIN)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_BIN)
	$(NOECHO) $(TOUCH) $(INST_BIN)$(DFSEP).exists

$(INST_SCRIPT)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_SCRIPT)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_SCRIPT)
	$(NOECHO) $(TOUCH) $(INST_SCRIPT)$(DFSEP).exists

$(INST_MAN1DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN1DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN1DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN1DIR)$(DFSEP).exists

$(INST_MAN3DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN3DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN3DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN3DIR)$(DFSEP).exists



# --- MakeMaker linkext section:

linkext :: $(LINKTYPE)
	$(NOECHO) $(NOOP)


# --- MakeMaker dlsyms section:


# --- MakeMaker dynamic section:

dynamic :: $(FIRST_MAKEFILE) $(INST_DYNAMIC) $(INST_BOOT)
	$(NOECHO) $(NOOP)


# --- MakeMaker dynamic_bs section:

BOOTSTRAP =


# --- MakeMaker dynamic_lib section:


# --- MakeMaker static section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make static"
static :: $(FIRST_MAKEFILE) $(INST_STATIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker static_lib section:


# --- MakeMaker manifypods section:

POD2MAN_EXE = $(PERLRUN) "-MExtUtils::Command::MM" -e pod2man "--"
POD2MAN = $(POD2MAN_EXE)


manifypods : pure_all  \
	lib/Convos/Plugin/Helpers.pm \
	lib/Convos/Chat.pm \
	lib/Convos/Archive.pm \
	lib/Convos/Loopback.pm \
	lib/Convos/User.pm \
	lib/Convos/Client.pm \
	lib/Convos/Core.pm \
	lib/Convos/Core/Archive.pm \
	lib/Convos/Core/Connection.pm \
	lib/Convos/Oembed.pm \
	lib/Convos.pm \
	lib/Convos/Core/Util.pm \
	lib/Convos/Command/backend.pm \
	lib/Convos/Core/Commands.pm
	$(NOECHO) $(POD2MAN) --section=3 --perm_rw=$(PERM_RW) \
	  lib/Convos/Plugin/Helpers.pm $(INST_MAN3DIR)/Convos::Plugin::Helpers.$(MAN3EXT) \
	  lib/Convos/Chat.pm $(INST_MAN3DIR)/Convos::Chat.$(MAN3EXT) \
	  lib/Convos/Archive.pm $(INST_MAN3DIR)/Convos::Archive.$(MAN3EXT) \
	  lib/Convos/Loopback.pm $(INST_MAN3DIR)/Convos::Loopback.$(MAN3EXT) \
	  lib/Convos/User.pm $(INST_MAN3DIR)/Convos::User.$(MAN3EXT) \
	  lib/Convos/Client.pm $(INST_MAN3DIR)/Convos::Client.$(MAN3EXT) \
	  lib/Convos/Core.pm $(INST_MAN3DIR)/Convos::Core.$(MAN3EXT) \
	  lib/Convos/Core/Archive.pm $(INST_MAN3DIR)/Convos::Core::Archive.$(MAN3EXT) \
	  lib/Convos/Core/Connection.pm $(INST_MAN3DIR)/Convos::Core::Connection.$(MAN3EXT) \
	  lib/Convos/Oembed.pm $(INST_MAN3DIR)/Convos::Oembed.$(MAN3EXT) \
	  lib/Convos.pm $(INST_MAN3DIR)/Convos.$(MAN3EXT) \
	  lib/Convos/Core/Util.pm $(INST_MAN3DIR)/Convos::Core::Util.$(MAN3EXT) \
	  lib/Convos/Command/backend.pm $(INST_MAN3DIR)/Convos::Command::backend.$(MAN3EXT) \
	  lib/Convos/Core/Commands.pm $(INST_MAN3DIR)/Convos::Core::Commands.$(MAN3EXT) 




# --- MakeMaker processPL section:


# --- MakeMaker installbin section:

EXE_FILES = script/convos

pure_all :: $(INST_SCRIPT)/convos
	$(NOECHO) $(NOOP)

realclean ::
	$(RM_F) \
	  $(INST_SCRIPT)/convos 

$(INST_SCRIPT)/convos : script/convos $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/convos
	$(CP) script/convos $(INST_SCRIPT)/convos
	$(FIXIN) $(INST_SCRIPT)/convos
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/convos



# --- MakeMaker subdirs section:

# none

# --- MakeMaker clean_subdirs section:
clean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean :: clean_subdirs
	- $(RM_F) \
	  $(BASEEXT).def so_locations \
	  tmon.out core.[0-9][0-9][0-9][0-9][0-9] \
	  core.*perl.*.? lib$(BASEEXT).def \
	  $(BOOTSTRAP) pm_to_blib \
	  core.[0-9][0-9][0-9][0-9] *$(OBJ_EXT) \
	  core.[0-9] $(BASEEXT).bso \
	  core MYMETA.yml \
	  $(INST_ARCHAUTODIR)/extralibs.all $(BASEEXT).exp \
	  pm_to_blib.ts *perl.core \
	  mon.out core.[0-9][0-9][0-9] \
	  blibdirs.ts perlmain.c \
	  core.[0-9][0-9] perl.exe \
	  *$(LIB_EXT) $(MAKE_APERL_FILE) \
	  $(INST_ARCHAUTODIR)/extralibs.ld perl \
	  MYMETA.json $(BASEEXT).x \
	  perl$(EXE_EXT) 
	- $(RM_RF) \
	  blib 
	- $(MV) $(FIRST_MAKEFILE) $(MAKEFILE_OLD) $(DEV_NULL)


# --- MakeMaker realclean_subdirs section:
realclean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker realclean section:
# Delete temporary files (via clean) and also delete dist files
realclean purge ::  clean realclean_subdirs
	- $(RM_F) \
	  $(FIRST_MAKEFILE) $(MAKEFILE_OLD) 
	- $(RM_RF) \
	  $(DISTVNAME) 


# --- MakeMaker metafile section:
metafile : create_distdir
	$(NOECHO) $(ECHO) Generating META.yml
	$(NOECHO) $(ECHO) '---' > META_new.yml
	$(NOECHO) $(ECHO) 'abstract: '\''Multiuser IRC proxy with web interface'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'author:' >> META_new.yml
	$(NOECHO) $(ECHO) '  - '\''Jan Henning Thorsen <jhthorsen@cpan.org>'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'build_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  IRC::Utils: 0.12' >> META_new.yml
	$(NOECHO) $(ECHO) '  Mojo::IRC: 0.0303' >> META_new.yml
	$(NOECHO) $(ECHO) '  Mojo::Redis: 0.992' >> META_new.yml
	$(NOECHO) $(ECHO) '  Mojolicious: 4.6' >> META_new.yml
	$(NOECHO) $(ECHO) '  Mojolicious::Plugin::AssetPack: 0.0502' >> META_new.yml
	$(NOECHO) $(ECHO) '  Parse::IRC: 1.18' >> META_new.yml
	$(NOECHO) $(ECHO) '  Time::Piece: 1.2' >> META_new.yml
	$(NOECHO) $(ECHO) '  Unicode::UTF8: 0.58' >> META_new.yml
	$(NOECHO) $(ECHO) 'configure_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  ExtUtils::MakeMaker: 0' >> META_new.yml
	$(NOECHO) $(ECHO) 'dynamic_config: 1' >> META_new.yml
	$(NOECHO) $(ECHO) 'generated_by: '\''ExtUtils::MakeMaker version 6.66, CPAN::Meta::Converter version 2.120921'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'license: artistic_2' >> META_new.yml
	$(NOECHO) $(ECHO) 'meta-spec:' >> META_new.yml
	$(NOECHO) $(ECHO) '  url: http://module-build.sourceforge.net/META-spec-v1.4.html' >> META_new.yml
	$(NOECHO) $(ECHO) '  version: 1.4' >> META_new.yml
	$(NOECHO) $(ECHO) 'name: Convos' >> META_new.yml
	$(NOECHO) $(ECHO) 'no_index:' >> META_new.yml
	$(NOECHO) $(ECHO) '  directory:' >> META_new.yml
	$(NOECHO) $(ECHO) '    - t' >> META_new.yml
	$(NOECHO) $(ECHO) '    - inc' >> META_new.yml
	$(NOECHO) $(ECHO) 'requires: {}' >> META_new.yml
	$(NOECHO) $(ECHO) 'resources:' >> META_new.yml
	$(NOECHO) $(ECHO) '  bugtracker: https://github.com/Nordaaker/convos/issues' >> META_new.yml
	$(NOECHO) $(ECHO) '  homepage: https://github.com/Nordaaker/convos' >> META_new.yml
	$(NOECHO) $(ECHO) '  license: http://www.opensource.org/licenses/artistic-license-2.0' >> META_new.yml
	$(NOECHO) $(ECHO) '  repository: https://github.com/Nordaaker/convos' >> META_new.yml
	$(NOECHO) $(ECHO) 'version: 0.1001' >> META_new.yml
	-$(NOECHO) $(MV) META_new.yml $(DISTVNAME)/META.yml
	$(NOECHO) $(ECHO) Generating META.json
	$(NOECHO) $(ECHO) '{' > META_new.json
	$(NOECHO) $(ECHO) '   "abstract" : "Multiuser IRC proxy with web interface",' >> META_new.json
	$(NOECHO) $(ECHO) '   "author" : [' >> META_new.json
	$(NOECHO) $(ECHO) '      "Jan Henning Thorsen <jhthorsen@cpan.org>"' >> META_new.json
	$(NOECHO) $(ECHO) '   ],' >> META_new.json
	$(NOECHO) $(ECHO) '   "dynamic_config" : 1,' >> META_new.json
	$(NOECHO) $(ECHO) '   "generated_by" : "ExtUtils::MakeMaker version 6.66, CPAN::Meta::Converter version 2.120921",' >> META_new.json
	$(NOECHO) $(ECHO) '   "license" : [' >> META_new.json
	$(NOECHO) $(ECHO) '      "artistic_2"' >> META_new.json
	$(NOECHO) $(ECHO) '   ],' >> META_new.json
	$(NOECHO) $(ECHO) '   "meta-spec" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "url" : "http://search.cpan.org/perldoc?CPAN::Meta::Spec",' >> META_new.json
	$(NOECHO) $(ECHO) '      "version" : "2"' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "name" : "Convos",' >> META_new.json
	$(NOECHO) $(ECHO) '   "no_index" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "directory" : [' >> META_new.json
	$(NOECHO) $(ECHO) '         "t",' >> META_new.json
	$(NOECHO) $(ECHO) '         "inc"' >> META_new.json
	$(NOECHO) $(ECHO) '      ]' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "prereqs" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "build" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "IRC::Utils" : "0.12",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Mojo::IRC" : "0.0303",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Mojo::Redis" : "0.992",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Mojolicious" : "4.6",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Mojolicious::Plugin::AssetPack" : "0.0502",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Parse::IRC" : "1.18",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Time::Piece" : "1.2",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Unicode::UTF8" : "0.58"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "configure" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "ExtUtils::MakeMaker" : "0"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "runtime" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {}' >> META_new.json
	$(NOECHO) $(ECHO) '      }' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "release_status" : "stable",' >> META_new.json
	$(NOECHO) $(ECHO) '   "resources" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "bugtracker" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "web" : "https://github.com/Nordaaker/convos/issues"' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "homepage" : "https://github.com/Nordaaker/convos",' >> META_new.json
	$(NOECHO) $(ECHO) '      "license" : [' >> META_new.json
	$(NOECHO) $(ECHO) '         "http://www.opensource.org/licenses/artistic-license-2.0"' >> META_new.json
	$(NOECHO) $(ECHO) '      ],' >> META_new.json
	$(NOECHO) $(ECHO) '      "repository" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "url" : "https://github.com/Nordaaker/convos"' >> META_new.json
	$(NOECHO) $(ECHO) '      }' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "version" : "0.1001"' >> META_new.json
	$(NOECHO) $(ECHO) '}' >> META_new.json
	-$(NOECHO) $(MV) META_new.json $(DISTVNAME)/META.json


# --- MakeMaker signature section:
signature :
	cpansign -s


# --- MakeMaker dist_basics section:
distclean :: realclean distcheck
	$(NOECHO) $(NOOP)

distcheck :
	$(PERLRUN) "-MExtUtils::Manifest=fullcheck" -e fullcheck

skipcheck :
	$(PERLRUN) "-MExtUtils::Manifest=skipcheck" -e skipcheck

manifest :
	$(PERLRUN) "-MExtUtils::Manifest=mkmanifest" -e mkmanifest

veryclean : realclean
	$(RM_F) *~ */*~ *.orig */*.orig *.bak */*.bak *.old */*.old 



# --- MakeMaker dist_core section:

dist : $(DIST_DEFAULT) $(FIRST_MAKEFILE)
	$(NOECHO) $(ABSPERLRUN) -l -e 'print '\''Warning: Makefile possibly out of date with $(VERSION_FROM)'\''' \
	  -e '    if -e '\''$(VERSION_FROM)'\'' and -M '\''$(VERSION_FROM)'\'' < -M '\''$(FIRST_MAKEFILE)'\'';' --

tardist : $(DISTVNAME).tar$(SUFFIX)
	$(NOECHO) $(NOOP)

uutardist : $(DISTVNAME).tar$(SUFFIX)
	uuencode $(DISTVNAME).tar$(SUFFIX) $(DISTVNAME).tar$(SUFFIX) > $(DISTVNAME).tar$(SUFFIX)_uu

$(DISTVNAME).tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME).tar $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME).tar
	$(POSTOP)

zipdist : $(DISTVNAME).zip
	$(NOECHO) $(NOOP)

$(DISTVNAME).zip : distdir
	$(PREOP)
	$(ZIP) $(ZIPFLAGS) $(DISTVNAME).zip $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(POSTOP)

shdist : distdir
	$(PREOP)
	$(SHAR) $(DISTVNAME) > $(DISTVNAME).shar
	$(RM_RF) $(DISTVNAME)
	$(POSTOP)


# --- MakeMaker distdir section:
create_distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"

distdir : create_distdir distmeta 
	$(NOECHO) $(NOOP)



# --- MakeMaker dist_test section:
disttest : distdir
	cd $(DISTVNAME) && $(ABSPERLRUN) Makefile.PL 
	cd $(DISTVNAME) && $(MAKE) $(PASTHRU)
	cd $(DISTVNAME) && $(MAKE) test $(PASTHRU)



# --- MakeMaker dist_ci section:

ci :
	$(PERLRUN) "-MExtUtils::Manifest=maniread" \
	  -e "@all = keys %{ maniread() };" \
	  -e "print(qq{Executing $(CI) @all\n}); system(qq{$(CI) @all});" \
	  -e "print(qq{Executing $(RCS_LABEL) ...\n}); system(qq{$(RCS_LABEL) @all});"


# --- MakeMaker distmeta section:
distmeta : create_distdir metafile
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -e q{META.yml};' \
	  -e 'eval { maniadd({q{META.yml} => q{Module YAML meta-data (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add META.yml to MANIFEST: $$$${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -f q{META.json};' \
	  -e 'eval { maniadd({q{META.json} => q{Module JSON meta-data (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add META.json to MANIFEST: $$$${'\''@'\''}\n"' --



# --- MakeMaker distsignature section:
distsignature : create_distdir
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'eval { maniadd({q{SIGNATURE} => q{Public-key signature (added by MakeMaker)}}) } ' \
	  -e '    or print "Could not add SIGNATURE to MANIFEST: $$$${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(TOUCH) SIGNATURE
	cd $(DISTVNAME) && cpansign -s



# --- MakeMaker install section:

install :: pure_install doc_install
	$(NOECHO) $(NOOP)

install_perl :: pure_perl_install doc_perl_install
	$(NOECHO) $(NOOP)

install_site :: pure_site_install doc_site_install
	$(NOECHO) $(NOOP)

install_vendor :: pure_vendor_install doc_vendor_install
	$(NOECHO) $(NOOP)

pure_install :: pure_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

doc_install :: doc_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

pure__install : pure_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

doc__install : doc_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_perl_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLARCHLIB)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLPRIVLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLARCHLIB) \
		$(INST_BIN) $(DESTINSTALLBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(SITEARCHEXP)/auto/$(FULLEXT)


pure_site_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLSITEARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLSITELIB) \
		$(INST_ARCHLIB) $(DESTINSTALLSITEARCH) \
		$(INST_BIN) $(DESTINSTALLSITEBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSITESCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLSITEMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLSITEMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(PERL_ARCHLIB)/auto/$(FULLEXT)

pure_vendor_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLVENDORARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLVENDORLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLVENDORARCH) \
		$(INST_BIN) $(DESTINSTALLVENDORBIN) \
		$(INST_SCRIPT) $(DESTINSTALLVENDORSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLVENDORMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLVENDORMAN3DIR)

doc_perl_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLPRIVLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_site_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLSITELIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_vendor_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLVENDORLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod


uninstall :: uninstall_from_$(INSTALLDIRS)dirs
	$(NOECHO) $(NOOP)

uninstall_from_perldirs ::
	$(NOECHO) $(UNINSTALL) $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist

uninstall_from_sitedirs ::
	$(NOECHO) $(UNINSTALL) $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist

uninstall_from_vendordirs ::
	$(NOECHO) $(UNINSTALL) $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist


# --- MakeMaker force section:
# Phony target to force checking subdirectories.
FORCE :
	$(NOECHO) $(NOOP)


# --- MakeMaker perldepend section:


# --- MakeMaker makefile section:
# We take a very conservative approach here, but it's worth it.
# We move Makefile to Makefile.old here to avoid gnu make looping.
$(FIRST_MAKEFILE) : Makefile.PL $(CONFIGDEP)
	$(NOECHO) $(ECHO) "Makefile out-of-date with respect to $?"
	$(NOECHO) $(ECHO) "Cleaning current config before rebuilding Makefile..."
	-$(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	-$(NOECHO) $(MV)   $(FIRST_MAKEFILE) $(MAKEFILE_OLD)
	- $(MAKE) $(USEMAKEFILE) $(MAKEFILE_OLD) clean $(DEV_NULL)
	$(PERLRUN) Makefile.PL 
	$(NOECHO) $(ECHO) "==> Your Makefile has been rebuilt. <=="
	$(NOECHO) $(ECHO) "==> Please rerun the $(MAKE) command.  <=="
	$(FALSE)



# --- MakeMaker staticmake section:

# --- MakeMaker makeaperl section ---
MAP_TARGET    = perl
FULLPERL      = /home/jhthorsen/perl5/perlbrew/perls/perl-5.18.1/bin/perl

$(MAP_TARGET) :: static $(MAKE_APERL_FILE)
	$(MAKE) $(USEMAKEFILE) $(MAKE_APERL_FILE) $@

$(MAKE_APERL_FILE) : $(FIRST_MAKEFILE) pm_to_blib
	$(NOECHO) $(ECHO) Writing \"$(MAKE_APERL_FILE)\" for this $(MAP_TARGET)
	$(NOECHO) $(PERLRUNINST) \
		Makefile.PL DIR= \
		MAKEFILE=$(MAKE_APERL_FILE) LINKTYPE=static \
		MAKEAPERL=1 NORECURS=1 CCCDLFLAGS=


# --- MakeMaker test section:

TEST_VERBOSE=0
TEST_TYPE=test_$(LINKTYPE)
TEST_FILE = test.pl
TEST_FILES = t/*.t
TESTDB_SW = -d

testdb :: testdb_$(LINKTYPE)

test :: $(TEST_TYPE) subdirs-test

subdirs-test ::
	$(NOECHO) $(NOOP)


test_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) "-MExtUtils::Command::MM" "-e" "test_harness($(TEST_VERBOSE), '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)

testdb_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) $(TESTDB_SW) "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)

test_ : test_dynamic

test_static :: test_dynamic
testdb_static :: testdb_dynamic


# --- MakeMaker ppd section:
# Creates a PPD (Perl Package Description) for a binary distribution.
ppd :
	$(NOECHO) $(ECHO) '<SOFTPKG NAME="$(DISTNAME)" VERSION="$(VERSION)">' > $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <ABSTRACT>Multiuser IRC proxy with web interface</ABSTRACT>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <AUTHOR>Jan Henning Thorsen &lt;jhthorsen@cpan.org&gt;</AUTHOR>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <ARCHITECTURE NAME="x86_64-linux-5.18" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <CODEBASE HREF="" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    </IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '</SOFTPKG>' >> $(DISTNAME).ppd


# --- MakeMaker pm_to_blib section:

pm_to_blib : $(FIRST_MAKEFILE) $(TO_INST_PM)
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/Convos/templates/event/welcome.html.ep blib/lib/Convos/templates/event/welcome.html.ep \
	  lib/Convos/templates/event/topic.html.ep blib/lib/Convos/templates/event/topic.html.ep \
	  lib/Convos/public/font/fontawesome-webfont.woff blib/lib/Convos/public/font/fontawesome-webfont.woff \
	  lib/Convos/public/image/logo.png blib/lib/Convos/public/image/logo.png \
	  lib/Convos/templates/event/rpl_namreply.html.ep blib/lib/Convos/templates/event/rpl_namreply.html.ep \
	  lib/Convos/public/sass/main.scss blib/lib/Convos/public/sass/main.scss \
	  lib/Convos/Chat.pm blib/lib/Convos/Chat.pm \
	  lib/Convos/Archive.pm blib/lib/Convos/Archive.pm \
	  lib/Convos/public/packed/convos-24520b065f62fbe702d11648f8a1c02f.css blib/lib/Convos/public/packed/convos-24520b065f62fbe702d11648f8a1c02f.css \
	  lib/Convos/templates/event/connection.html.ep blib/lib/Convos/templates/event/connection.html.ep \
	  lib/Convos/public/image/icon-196.png blib/lib/Convos/public/image/icon-196.png \
	  lib/Convos/public/font/fontawesome-webfont.afm blib/lib/Convos/public/font/fontawesome-webfont.afm \
	  lib/Convos/public/sass/.sass-cache/49c3749e8d67888e6efa4aaa046500d4537c7173/selectize.scssc blib/lib/Convos/public/sass/.sass-cache/49c3749e8d67888e6efa4aaa046500d4537c7173/selectize.scssc \
	  lib/Convos/public/js/jquery.helpers.js blib/lib/Convos/public/js/jquery.helpers.js \
	  lib/Convos/Oembed.pm blib/lib/Convos/Oembed.pm \
	  lib/Convos/public/js/globals.js blib/lib/Convos/public/js/globals.js \
	  lib/Convos/Core/Connection.pm blib/lib/Convos/Core/Connection.pm \
	  lib/Convos/templates/oembed/image.html.ep blib/lib/Convos/templates/oembed/image.html.ep \
	  lib/Convos/templates/event/whois_channels.html.ep blib/lib/Convos/templates/event/whois_channels.html.ep \
	  lib/Convos/public/js/jquery.hotkeys.min.js blib/lib/Convos/public/js/jquery.hotkeys.min.js \
	  lib/Convos/public/image/landing-page-example-chat.jpeg blib/lib/Convos/public/image/landing-page-example-chat.jpeg \
	  lib/Convos/templates/client/view.html.ep blib/lib/Convos/templates/client/view.html.ep \
	  lib/Convos/Loopback.pm blib/lib/Convos/Loopback.pm \
	  lib/Convos/public/js/jquery.min.js blib/lib/Convos/public/js/jquery.min.js \
	  lib/Convos/convos.conf blib/lib/Convos/convos.conf \
	  lib/Convos.pm blib/lib/Convos.pm \
	  lib/Convos/templates/event/historic_messages.html.ep blib/lib/Convos/templates/event/historic_messages.html.ep \
	  lib/Convos/templates/client/notification_list.html.ep blib/lib/Convos/templates/client/notification_list.html.ep \
	  lib/Convos/templates/index.html.ep blib/lib/Convos/templates/index.html.ep \
	  lib/Convos/templates/user/login.html.ep blib/lib/Convos/templates/user/login.html.ep 
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/Convos/templates/event/nick_parted.html.ep blib/lib/Convos/templates/event/nick_parted.html.ep \
	  lib/Convos/public/convos.manifest blib/lib/Convos/public/convos.manifest \
	  lib/Convos/public/js/jquery.fastbutton.min.js blib/lib/Convos/public/js/jquery.fastbutton.min.js \
	  lib/Convos/public/image/help.png blib/lib/Convos/public/image/help.png \
	  lib/Convos/templates/event/mode.html.ep blib/lib/Convos/templates/event/mode.html.ep \
	  lib/Convos/Client.pm blib/lib/Convos/Client.pm \
	  lib/Convos/templates/inc/alert.html.ep blib/lib/Convos/templates/inc/alert.html.ep \
	  lib/Convos/public/sass/.sass-cache/a951694f82d90dd3c3e0af05ea817ae5f104c7b7/selectize.scssc blib/lib/Convos/public/sass/.sass-cache/a951694f82d90dd3c3e0af05ea817ae5f104c7b7/selectize.scssc \
	  lib/Convos/public/js/ws-reconnecting.js blib/lib/Convos/public/js/ws-reconnecting.js \
	  lib/Convos/Command/backend.pm blib/lib/Convos/Command/backend.pm \
	  lib/Convos/templates/event/whois.html.ep blib/lib/Convos/templates/event/whois.html.ep \
	  lib/Convos/templates/event/nick_quit.html.ep blib/lib/Convos/templates/event/nick_quit.html.ep \
	  lib/Convos/public/js/jquery.nanoscroller.min.js blib/lib/Convos/public/js/jquery.nanoscroller.min.js \
	  lib/Convos/templates/event/server_message.html.ep blib/lib/Convos/templates/event/server_message.html.ep \
	  lib/Convos/Core.pm blib/lib/Convos/Core.pm \
	  lib/Convos/Core/Archive.pm blib/lib/Convos/Core/Archive.pm \
	  lib/Convos/public/js/jquery.pjax.min.js blib/lib/Convos/public/js/jquery.pjax.min.js \
	  lib/Convos/Core/Util.pm blib/lib/Convos/Core/Util.pm \
	  lib/Convos/public/js/jquery.pjax.js blib/lib/Convos/public/js/jquery.pjax.js \
	  lib/Convos/templates/event/action_message.html.ep blib/lib/Convos/templates/event/action_message.html.ep \
	  lib/Convos/public/js/convos.chat.js blib/lib/Convos/public/js/convos.chat.js \
	  lib/Convos/templates/event/message.html.ep blib/lib/Convos/templates/event/message.html.ep \
	  lib/Convos/User.pm blib/lib/Convos/User.pm \
	  lib/Convos/templates/user/register.html.ep blib/lib/Convos/templates/user/register.html.ep \
	  lib/Convos/templates/event/topic_by.html.ep blib/lib/Convos/templates/event/topic_by.html.ep \
	  lib/Convos/public/image/logo.svg blib/lib/Convos/public/image/logo.svg \
	  lib/Convos/public/sass/selectize.scss blib/lib/Convos/public/sass/selectize.scss \
	  lib/Convos/public/js/jquery.doubletap.js blib/lib/Convos/public/js/jquery.doubletap.js \
	  lib/Convos/public/packed/main-24520b065f62fbe702d11648f8a1c02f.css blib/lib/Convos/public/packed/main-24520b065f62fbe702d11648f8a1c02f.css \
	  lib/Convos/templates/event/remove_conversation.html.ep blib/lib/Convos/templates/event/remove_conversation.html.ep 
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/Convos/public/js/jquery.fastbutton.js blib/lib/Convos/public/js/jquery.fastbutton.js \
	  lib/Convos/templates/not_found.production.html.ep blib/lib/Convos/templates/not_found.production.html.ep \
	  lib/Convos/public/js/selectize.min.js blib/lib/Convos/public/js/selectize.min.js \
	  lib/Convos/templates/client/conversation_list.html.ep blib/lib/Convos/templates/client/conversation_list.html.ep \
	  lib/Convos/public/font/fontawesome-webfont.ttf blib/lib/Convos/public/font/fontawesome-webfont.ttf \
	  lib/Convos/templates/client/conversation.html.ep blib/lib/Convos/templates/client/conversation.html.ep \
	  lib/Convos/templates/event/help.html.ep blib/lib/Convos/templates/event/help.html.ep \
	  lib/Convos/templates/event/add_conversation.html.ep blib/lib/Convos/templates/event/add_conversation.html.ep \
	  lib/Convos/public/image/loader-facebook.gif blib/lib/Convos/public/image/loader-facebook.gif \
	  lib/Convos/Core/Commands.pm blib/lib/Convos/Core/Commands.pm \
	  lib/Convos/templates/event/user.html.ep blib/lib/Convos/templates/event/user.html.ep \
	  lib/Convos/templates/user/invite_only.html.ep blib/lib/Convos/templates/user/invite_only.html.ep \
	  lib/Convos/templates/oembed/youtube.html.ep blib/lib/Convos/templates/oembed/youtube.html.ep \
	  lib/Convos/public/image/icon-128.png blib/lib/Convos/public/image/icon-128.png \
	  lib/Convos/templates/empty.html.ep blib/lib/Convos/templates/empty.html.ep \
	  lib/Convos/public/image/loader-squares-circle.gif blib/lib/Convos/public/image/loader-squares-circle.gif \
	  lib/Convos/templates/event/nick_change.html.ep blib/lib/Convos/templates/event/nick_change.html.ep \
	  lib/Convos/public/js/jquery.hotkeys.js blib/lib/Convos/public/js/jquery.hotkeys.js \
	  lib/Convos/public/packed/convos-671e8d97976e1dbcfbd351eeac7cb5bf.js blib/lib/Convos/public/packed/convos-671e8d97976e1dbcfbd351eeac7cb5bf.js \
	  lib/Convos/public/favicon.ico blib/lib/Convos/public/favicon.ico \
	  lib/Convos/templates/layouts/default.html.ep blib/lib/Convos/templates/layouts/default.html.ep \
	  lib/Convos/templates/event/nick_joined.html.ep blib/lib/Convos/templates/event/nick_joined.html.ep \
	  lib/Convos/public/font/fontawesome-webfont.eot blib/lib/Convos/public/font/fontawesome-webfont.eot \
	  lib/Convos/templates/event/channel_list.html.ep blib/lib/Convos/templates/event/channel_list.html.ep \
	  lib/Convos/Plugin/Helpers.pm blib/lib/Convos/Plugin/Helpers.pm 
	$(NOECHO) $(TOUCH) pm_to_blib


# --- MakeMaker selfdocument section:


# --- MakeMaker postamble section:


# End.
