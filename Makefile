PREFIX ?= /usr
BINDIR ?= $(PREFIX)/bin
DOCDIR ?= $(PREFIX)/share/xutils
MANDIR ?= $(PREFIX)/share/man

#set this to $HOME for a local install
#Debian uses /etc/X11/app-defaults
#This does NOT respect PREFIX, since X does not search there.
APPDEFDIR ?= /usr/lib/X11/app-defaults

CPPFLAGS=-DHAVE_STRLCAT -DHAVE_WCHAR_H -DHAVE_WCTYPE_H
LIBS=-lX11 -lXext -lXau -lXdmcp -lXaw -lXmu -lXt
FONTUTIL= ucs2any bdftruncate bdftopcf
BINS=xlsfonts xwininfo xprop xkill xfontsel xmessage xcalc xev $(FONTUTIL)
MAN =man/xlsfonts.1 man/xwininfo.1 man/xprop.1 \
 man/xkill.1 man/xfontsel.1 man/xmessage.1 \
 man/xcalc.1 man/xev.1 \
 man/ucs2any.1 man/bdftruncate.1 man/bdftopcf.1

.SUFFIXES: .c .o .man .1 .3 .7

default: $(BINS) $(MAN)

clean:
	rm -f *.o $(BINS) $(MAN)

install: $(BINS) $(MAN)
	install -d $(DESTDIR)$(BINDIR)
	for B in $(BINS); do install -m 0755 $$B $(DESTDIR)$(BINDIR); done
	install -d $(DESTDIR)$(MANDIR)
	for M in $(MAN); do install -m 0644 $$M $(DESTDIR)$(MANDIR); done
	install -d $(DESTDIR)$(DOCDIR)
	cp COPYING.* $(DESTDIR)$(DOCDIR)
	install -d $(DESTDIR)$(APPDEFDIR)
	cp app-defaults/* $(DESTDIR)$(APPDEFDIR)

xlsfonts:
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $@.c dsimple.c clientwin.c $(LIBS)
xprop:
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $@.c dsimple.c clientwin.c $(LIBS)
xev:
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $@.c $(LIBS)
xkill:
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $@.c $(LIBS)
xfontsel:
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $@.c ULabel.c $(LIBS)
xwininfo:
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $@.c dsimple.c clientwin.c $(LIBS)
xmessage:
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $@.c makeform.c readfile.c $(LIBS)
.man.1:
	sed -e 's|__vendorversion__|"TinyX" "X Version 11"|' \
	-e 's|__xorgversion__|"X Version 11"|' \
	-e 's|__projectroot__|/usr/local|g' -e 's|__apploaddir__||' \
	-e 's|__appmansuffix__|1|g' -e 's|__libmansuffix__|3|g' \
	-e 's|__adminmansuffix__|8|g' -e 's|__miscmansuffix__|7|g' -e 's|__filemansuffix__|5|g' \
	< $< > $@
xcalc:
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ actions.c math.c xcalc.c $(LDFLAGS) $(LIBS)
fontutils: $(FONTUTIL)

bdftopcf:
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $@.c $(LDFLAGS) -lXfont -lz
