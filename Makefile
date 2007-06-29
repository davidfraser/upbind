name := upbind
version := 0.1

sample1files=autodns.conf mail nameserver services
sample2files=autodns.conf dynamic mail nameserver services users
samplefiles=$(foreach file,${sample1files},samples/domain1/${file}) $(foreach file,${sample2files},samples/domain2/${file})
srcfiles=Makefile dnswatch dnswatch-d dnswatch.rc makezone upbind.spec $(samplefiles)

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
	install -D dnswatch ${DESTDIR}/etc/init.d/dnswatch
	install -D dnswatch.rc ${DESTDIR}/etc/dnswatch.rc
	install -D dnswatch-d ${DESTDIR}/usr/sbin/dnswatch-d
	install -D makezone ${DESTDIR}/usr/bin/makezone

rpm:	tarball
rpm:
	rpmbuild -ta ${name}-${version}.tar.gz

