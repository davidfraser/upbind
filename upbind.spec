# When not doing betas comment this out
# NOTE: %defines in spec files are evaluated in comments so the correct
#       way to comment it out is to replace the % with #
#define beta 7

%if 0%{?beta}
%define upbindver %(echo "0.1" | sed -e 's/beta.*//')
%else
%define upbindver 0.1
%endif

Summary:	A utility for easily managing and updating zonefiles for BIND
Name:		upbind
Version:	%upbindver
Release:	0%{?beta:.beta%{beta}}
License:	GPL
# TODO: check best group
Group:		Applications/Internet
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
/etc/init.d/dnswatch
/usr/sbin/dnswatch-d
/etc/dnswatch.rc
/usr/bin/makezone
%doc samples/domain1/autodns.conf
%doc samples/domain1/mail
%doc samples/domain1/nameserver
%doc samples/domain1/services
%doc samples/domain2/autodns.conf
%doc samples/domain2/dynamic
%doc samples/domain2/mail
%doc samples/domain2/nameserver
%doc samples/domain2/services
%doc samples/domain2/users

