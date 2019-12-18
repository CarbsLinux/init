# See license for licensing details

PREFIX=/usr

install:
	@install -Dm644 inittab ${DESTDIR}/etc/inittab
	@install -Dm755 rc.boot ${DESTDIR}${PREFIX}/lib/init/rc.boot
	@install -Dm755 rc.shutdown ${DESTDIR}${PREFIX}/lib/init/rc.shutdown

uninstall:
	@rm -f ${DESTDIR}/etc/inittab
	@rm -f ${DESTDIR}${PREFIX}/lib/init/rc.boot
	@rm -f ${DESTDIR}${PREFIX}/lib/init/rc.shutdown

