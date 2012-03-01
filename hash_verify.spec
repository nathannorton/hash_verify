%define ruby_sitelib %(ruby -rrbconfig -e "puts Config::CONFIG['sitelibdir']")
%define binlocaldir /etc/local/bin

Name: hash_verify
Summary: Genaerate hashes of files and publish them to a mongo instance
Version: 1.0
Release: 1%{org_tag}%{dist}
Group: Applications/Internet
License: GPL
Source: hash_verify.tar.gz

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch: noarch
Requires: rubygem-mongo
Requires: rubygem-bson


%description
This application will generate hashes of files defined in the config file,
it will then publish these hashes to a mongo instance for later querying.

If used in query mode you can query values of hashes and do an action if they
are the same (for eample you can delete a file if we can see it has 
been backed up to the backup server)

%prep
%setup -q -n %{name}

%build

find . \( -name "*.orig" -o -name "*~" -o -name .cvsignore \) -print0 | xargs -0 rm -f
find . -type f -print0 | xargs -0 chmod -x
ls -l

%install
rm -rf $RPM_BUILD_ROOT

mkdir -p %{buildroot}%{ruby_sitelib}/hash_verify
install -m0644 hash_verify.rb %{buildroot}%{ruby_sitelib}/
install -m0644 lib/database.rb %{buildroot}%{ruby_sitelib}/hash_verify/database.rb
install -m0644 lib/config.rb %{buildroot}%{ruby_sitelib}/hash_verify/config.rb
install -m0644 lib/hasher.rb %{buildroot}%{ruby_sitelib}/hash_verify/hasher.rb


install -p -d -m755 $RPM_BUILD_ROOT%{binlocaldir}/
install -m700 bin/hash_verify $RPM_BUILD_ROOT%{binlocaldir}/
install -Dp -m0640 conf/hash_verify.conf %{buildroot}%{_sysconfdir}/hash_verify/
install -Dp -m0644 conf/hash_verify.cron %{buildroot}%{_sysconfdir}/cron.d/hash_verify


%clean
rm -rf $RPM_BUILD_ROOT


%post

%files
%defattr(-,root,root)
%{binlocaldir}/hash_verify
%config %{_sysconfdir}/hash_verify.conf
%{_sysconfdir}/cron.d/hash_verify
%{ruby_sitelib}/hash_verify/*


%changelog
* Thu Mar 01 2012 Nathan Norton <nathan@example.com> - 1.0
- initial spec file
