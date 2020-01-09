# See license for licensing details

PREFIX=/usr
INITDIR=${PREFIX}/lib/init

install:
	mkdir -p ${DESTDIR}/etc
	sed 's#INITDIR#${INITDIR}#g' < inittab > ${DESTDIR}/etc/inittab
	chmod 644 ${DESTDIR}/etc/inittab
	install -Dm644 rc.conf ${DESTDIR}/etc/init/rc.conf
	install -Dm755 rc.boot ${DESTDIR}${INITDIR}/rc.boot
	install -Dm755 rc.shutdown ${DESTDIR}${INITDIR}/rc.shutdown

uninstall:
	rm -f ${DESTDIR}/etc/inittab
	rm -f ${DESTDIR}/etc/init/rc.conf
	rm -f ${DESTDIR}${INITDIR}/rc.boot
	rm -f ${DESTDIR}${INITDIR}/rc.shutdown

