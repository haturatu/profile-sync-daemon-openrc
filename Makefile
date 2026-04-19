PREFIX ?= /bin
INITD_DIR ?= /etc/user/init.d
INSTALL ?= install
LN ?= ln
RM ?= rm
DESTDIR ?=

PROGRAM := profile-sync-daemon
LINK := psd
SERVICE := psd

.PHONY: all install uninstall

all:

install:
	$(INSTALL) -d "$(DESTDIR)$(PREFIX)" "$(DESTDIR)$(INITD_DIR)"
	$(INSTALL) -m 0755 "$(PROGRAM)" "$(DESTDIR)$(PREFIX)/$(PROGRAM)"
	$(INSTALL) -m 0755 "$(SERVICE)" "$(DESTDIR)$(INITD_DIR)/$(SERVICE)"
	$(RM) -f "$(DESTDIR)$(PREFIX)/$(LINK)"
	$(LN) -s "$(PROGRAM)" "$(DESTDIR)$(PREFIX)/$(LINK)"

uninstall:
	$(RM) -f \
		"$(DESTDIR)$(PREFIX)/$(LINK)" \
		"$(DESTDIR)$(PREFIX)/$(PROGRAM)" \
		"$(DESTDIR)$(INITD_DIR)/$(SERVICE)"
