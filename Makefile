# See license for licensing details

PREFIX=/usr
INITDIR=${PREFIX}/lib/init

install:
	mkdir -p ${DESTDIR}/etc
	sed 's#INITDIR#${INITDIR}#g' < inittab > ${DESTDIR}/etc/inittab
	chmod 644 ${DESTDIR}/etc/inittab
	install -Dm644 rc.conf ${DESTDIR}${INITDIR}/rc.conf
	sed 's#PREFIX#${PREFIX}#g' < rc.boot > ${DESTDIR}${INITDIR}/rc.boot
	sed 's#PREFIX#${PREFIX}#g' < rc.shutdown > ${DESTDIR}${INITDIR}/rc.shutdown
	chmod 755 ${DESTDIR}${INITDIR}/rc.boot
	chmod 755 ${DESTDIR}${INITDIR}/rc.shutdown

uninstall:
	rm -f ${DESTDIR}/etc/inittab
	rm -f ${DESTDIR}${INITDIR}/rc.conf
	rm -f ${DESTDIR}${INITDIR}/rc.boot
	rm -f ${DESTDIR}${INITDIR}/rc.shutdown

