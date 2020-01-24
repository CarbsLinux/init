# See license for licensing details

PREFIX=/usr
INITDIR=${PREFIX}/lib/init
MAN8=${PREFIX}/share/man/man8
VERSION=0.5.2

install:
	mkdir -p ${DESTDIR}/etc
	install -Dm644 rc.conf ${DESTDIR}/etc/init/rc.conf
	install -Dm644 rc.lib ${DESTDIR}${INITDIR}/rc.lib
	install -Dm755 rc.local ${DESTDIR}/etc/init/rc.local
	sed 's#INITDIR#${INITDIR}#g' < rc.boot > ${DESTDIR}${INITDIR}/rc.boot
	sed 's#INITDIR#${INITDIR}#g' < rc.shutdown > ${DESTDIR}${INITDIR}/rc.shutdown
	chmod 755 ${DESTDIR}${INITDIR}/rc.boot ${DESTDIR}${INITDIR}/rc.shutdown
	install -Dm644 README ${DESTDIR}${INITDIR}/README
	install -Dm644 init.8 ${DESTDIR}${MAN8}/init.8

uninstall:
	rm -f ${DESTDIR}/etc/init/rc.conf
	rm -f ${DESTDIR}/etc/init/rc.local
	rm -f ${DESTDIR}${INITDIR}/rc.boot
	rm -f ${DESTDIR}${INITDIR}/rc.shutdown
	rm -f ${DESTDIR}${INITDIR}/rc.lib
	rm -f ${DESTDIR}${INITDIR}/README
	rm -f ${DESTDIR}${MAN8}/init.8

dist:
	mkdir -p init-${VERSION}
	cp LICENSE Makefile README rc.boot rc.conf rc.lib rc.local \
		rc.shutdown init.8 init-${VERSION}
	tar -cf init-${VERSION}.tar init-${VERSION}
	gzip init-${VERSION}.tar
	rm -rf init-${VERSION}
