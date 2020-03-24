# See license for licensing details

PREFIX  = /usr
INITDIR = ${PREFIX}/lib/init
BINDIR  = ${PREFIX}/bin
CC      = cc

all: bin/shalt

bin/shalt:
	${CC} -o bin/shalt bin/shalt.c

clean:
	rm -f bin/shalt

install: bin/shalt
	mkdir -p ${DESTDIR}/etc
	install -Dm755 -t ${DESTDIR}${BINDIR} bin/shalt
	install -Dm644 rc.conf ${DESTDIR}/etc/init/rc.conf
	install -Dm644 rc.lib ${DESTDIR}${INITDIR}/rc.lib
	install -Dm644 -t ${DESTDIR}/etc/init/ contrib/getty.boot contrib/runit.boot
	install -Dm755 rc.local ${DESTDIR}/etc/init/rc.local
	sed 's#INITDIR#${INITDIR}#g' < rc.boot > ${DESTDIR}${INITDIR}/rc.boot
	sed 's#INITDIR#${INITDIR}#g' < rc.shutdown > ${DESTDIR}${INITDIR}/rc.shutdown
	chmod 755 ${DESTDIR}${INITDIR}/rc.boot ${DESTDIR}${INITDIR}/rc.shutdown
	install -Dm644 README ${DESTDIR}${INITDIR}/README

uninstall:
	rm -f ${DESTDIR}${BINDIR}/shalt
	rm -f ${DESTDIR}/etc/init/rc.conf
	rm -f ${DESTDIR}/etc/init/rc.local
	rm -f ${DESTDIR}/etc/init/getty.boot ${DESTDIR}/etc/init/runit.boot
	rm -f ${DESTDIR}${INITDIR}/rc.boot
	rm -f ${DESTDIR}${INITDIR}/rc.shutdown
	rm -f ${DESTDIR}${INITDIR}/rc.lib
	rm -f ${DESTDIR}${INITDIR}/README


.PHONY: all clean install uninstall
