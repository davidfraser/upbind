# When not doing betas comment this out
# NOTE: %defines in spec files are evaluated in comments so the correct
#       way to comment it out is to replace the % with #
#define beta 7

%if 0%{?beta}
%define upbindver %(echo "0.1" | sed -e 's/beta.*//')
%else
%define upbindver 0.1
%endif

# TODO: mark this as being noarch rather than building for i386/x64 etc

Summary:	A utility for easily managing and updating zonefiles for BIND
Name:		upbind
Version:	%upbindver
Release:	0%{?beta:.beta%{beta}}
License:	GPL
Group:		System Environment/Daemons
# TODO: create this web address
URL:		http://open.sjsoft.com/utilcode/upbind/
Source:		http://open.sjsoft.com/download/%{name}-%{upbindver}.tar.gz
BuildRoot:	%{_tmppath}/%{name}-%{version}-root

# Generic Build requirements
Requires:	python
Requires:	bind

%description
Upbind lets you maintain DNS definitions in a simple set of text files, and watches these files and regenerates zone files automatically. It tells bind to reload the zone files whenever they change, and generates zone serial numbers.

%prep
%setup

%build

%install
make DESTDIR=$RPM_BUILD_ROOT install

%clean
rm -rf %{buildroot}

%files
/etc/init.d/upbind
/usr/sbin/upbind-watcher
%config /etc/upbind.rc
%dir /etc/upbind
/usr/bin/upbind-makezone
%doc samples/domain1/upbind.conf
%doc samples/domain1/mail
%doc samples/domain1/nameserver
%doc samples/domain1/services
%doc samples/domain2/upbind.conf
%doc samples/domain2/dynamic
%doc samples/domain2/mail
%doc samples/domain2/nameserver
%doc samples/domain2/services
%doc samples/domain2/users

