# See license for licensing details

PREFIX=/usr
INITDIR=${PREFIX}/lib/init
VERSION=0.4.2

install:
	mkdir -p ${DESTDIR}/etc
	sed 's#INITDIR#${INITDIR}#g' < inittab > ${DESTDIR}/etc/inittab
	chmod 644 ${DESTDIR}/etc/inittab
	install -Dm644 rc.conf ${DESTDIR}/etc/init/rc.conf
	install -Dm644 rc.lib ${DESTDIR}${INITDIR}/rc.lib
	install -Dm755 rc.local ${DESTDIR}/etc/init/rc.local
	sed 's#INITDIR#${INITDIR}#g' < rc.boot > ${DESTDIR}${INITDIR}/rc.boot
	sed 's#INITDIR#${INITDIR}#g' < rc.shutdown > ${DESTDIR}${INITDIR}/rc.shutdown
	chmod 755 ${DESTDIR}${INITDIR}/rc.boot ${DESTDIR}${INITDIR}/rc.shutdown
	install -Dm644 README ${DESTDIR}${INITDIR}/README

uninstall:
	rm -f ${DESTDIR}/etc/inittab
	rm -f ${DESTDIR}/etc/init/rc.conf
	rm -f ${DESTDIR}/etc/init/rc.local
	rm -f ${DESTDIR}${INITDIR}/rc.boot
	rm -f ${DESTDIR}${INITDIR}/rc.shutdown
	rm -f ${DESTDIR}${INITDIR}/rc.lib
	rm -f ${DESTDIR}${INITDIR}/README

dist:
	mkdir -p init-${VERSION}
	cp LICENSE Makefile README inittab rc.boot rc.conf rc.lib rc.local \
		rc.shutdown init-${VERSION}
	tar -cf init-${VERSION}.tar init-${VERSION}
	gzip init-${VERSION}.tar
	rm -rf init-${VERSION}
