maintainer 'THomas Vincent'
maintainer_email 'thomasvincent@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures snmp on redhat, centos, ubuntu, debian, windows, aix, solaris2'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
name 'snmp'
version '4.0.2'

recipe 'snmp', 'Installs and configures snmpd'

%w(ubuntu debian redhat centos scientific fedora suse).each do |os|
  supports os
end
