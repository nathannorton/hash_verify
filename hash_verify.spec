%define binlocaldir /etc/local/bin

Name: hashii
Summary: Generate hashes of files and publish them to a mongo instance
Version: 0.9
Release: 1%{org_tag}%{dist}
Group: Applications/Internet
License: GPL
#Source: hashii-%{version}.tar.gz
#Source: hashii
Source: hashii.tar.gz

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch: noarch
Requires: rubygem-mongo
Requires: rubygem-bson


%description
This application will generate hashes of fiels defined in the config file,
it will then publish these hashes to a mongo instance for later querying.

If used in query mode you can query values of hashes and do an action if they
are the same ( for eample you can delete a file if we can see it has 
been backed up to the backup server)

%prep
%setup -q -n %{name}

%build

find . \( -name "*.orig" -o -name "*~" -o -name .cvsignore \) -print0 | \
								xargs -0 rm -f
find . -type f -print0 | xargs -0 chmod -x
ls -l

%install
rm -rf $RPM_BUILD_ROOT

install -p -d -m755 $RPM_BUILD_ROOT%{binlocaldir}/
install -m700 hashii $RPM_BUILD_ROOT%{binlocaldir}/
install -Dp -m0640 hashii.conf %{buildroot}%{_sysconfdir}/
install -Dp -m0644 hashii.cron %{buildroot}%{_sysconfdir}/cron.d/hashii


%clean
rm -rf $RPM_BUILD_ROOT


%post

%files
%defattr(-,root,root)
%{binlocaldir}/hashii
%config %{_sysconfdir}/hashii.conf
%{_sysconfdir}/cron.d/hashii

%changelog

