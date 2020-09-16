# See license for licensing details

PREFIX  = /usr
INITDIR = ${PREFIX}/lib/init
BINDIR  = ${PREFIX}/bin
CONFDIR = /etc/init
CC      = cc

CFLAGS  = -std=c99 -Wall -pedantic -D_XOPEN_SOURCE=500
LDFLAGS = -static

BIN = bin/shalt

all: ${BIN}

.c:
	${CC} ${CFLAGS} ${LDFLAGS} -o $@ $<

clean:
	rm -f ${BIN} ${OBJ}

install: ${BIN}
	mkdir -p ${DESTDIR}${CONFDIR} ${DESTDIR}${INITDIR} ${DESTDIR}${BINDIR}
	cp bin/shalt ${DESTDIR}${BINDIR}/shalt
	chmod 755 ${DESTDIR}${BINDIR}/shalt
	cp contrib/respawn ${DESTDIR}${BINDIR}/respawn
	chmod 755 ${DESTDIR}${BINDIR}/respawn
	cp rc.lib rc.boot rc.shutdown ${DESTDIR}${INITDIR}
	chmod 755 ${DESTDIR}${INITDIR}/rc.boot ${DESTDIR}${INITDIR}/rc.shutdown
	cp rc.conf contrib/runit.boot contrib/getty.boot ${DESTDIR}${CONFDIR}
	chmod 644 ${DESTDIR}${CONFDIR}/rc.conf ${DESTDIR}${CONFDIR}/runit.boot \
		${DESTDIR}${CONFDIR}/getty.boot

uninstall:
	rm -f ${DESTDIR}${BINDIR}/shalt
	rm -f ${DESTDIR}${CONFDIR}/rc.conf
	rm -f ${DESTDIR}${CONFDIR}/getty.boot ${DESTDIR}${CONFDIR}/runit.boot
	rm -f ${DESTDIR}${INITDIR}/rc.boot
	rm -f ${DESTDIR}${INITDIR}/rc.shutdown
	rm -f ${DESTDIR}${INITDIR}/rc.lib
	rm -f ${DESTDIR}${INITDIR}/README


.PHONY: all clean install uninstall
