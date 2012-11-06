name := upbind
python ?= python
defined_version := $(shell env $(python) -c "import upbind; print upbind.version")
version ?= ${defined_version}

defined_python_sitelib := $(shell env $(python) -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")
python_sitelib ?= ${defined_python_sitelib}
$(warning ${python_sitelib} ${version})

sample1files=upbind.conf mail nameserver services
sample2files=upbind.conf dynamic mail nameserver services users
samplefiles=$(foreach file,${sample1files},samples/domain1/${file}) $(foreach file,${sample2files},samples/domain2/${file})
srcfiles=Makefile LICENSE upbind upbind-edit upbind-watcher test.rc upbind.rc upbind-makezone upbind.spec upbind.py $(samplefiles)

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
	install -D upbind.py ${DESTDIR}${python_sitelib}/upbind.py
	install -D upbind-watcher ${DESTDIR}/usr/sbin/upbind-watcher
	install -D upbind-makezone ${DESTDIR}/usr/bin/upbind-makezone
	install -D upbind-edit ${DESTDIR}/usr/sbin/upbind-edit
	install -D LICENSE ${DESTDIR}/usr/share/doc/upbind/LICENSE
	install -d ${DESTDIR}/etc/upbind/
rpm:	tarball
rpm:
	rpmbuild -ta --define="upbind_version ${version}" --define="python_sitelib ${python_sitelib}" ${name}-${version}.tar.gz

