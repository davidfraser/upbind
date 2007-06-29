name := upbind
version := 0.1

sample1files=upbind.conf mail nameserver services
sample2files=upbind.conf dynamic mail nameserver services users
samplefiles=$(foreach file,${sample1files},samples/domain1/${file}) $(foreach file,${sample2files},samples/domain2/${file})
srcfiles=Makefile upbind upbind-watcher upbind.rc upbind-makezone upbind.spec $(samplefiles)

${name}-${version}.tar.gz: targetdir=${name}-${version}
${name}-${version}.tar.gz: $(srcfiles)
${name}-${version}.tar.gz:
	rm -fr ${targetdir}
	mkdir ${targetdir}
	mkdir ${targetdir}/samples
	mkdir ${targetdir}/samples/domain1
	mkdir ${targetdir}/samples/domain2
	$(foreach file,$(srcfiles),cp -p ${file} ${targetdir}/${file};)
	tar -czf $@ ${targetdir}
	rm -fr ${targetdir}

tarball: ${name}-${version}.tar.gz

install: $(srcfiles)
install: DESTDIR ?= /
install:
	install -D upbind ${DESTDIR}/etc/init.d/upbind
	install -D upbind.rc ${DESTDIR}/etc/upbind.rc
	install -D upbind-watcher ${DESTDIR}/usr/sbin/upbind-watcher
	install -D upbind-makezone ${DESTDIR}/usr/bin/upbind-makezone

rpm:	tarball
rpm:
	rpmbuild -ta ${name}-${version}.tar.gz

