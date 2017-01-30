name 'tcp_wrappers'
maintainer 'Thomas Vincent'
maintainer_email 'thomasvincent@gmail.com'
license 'Apache 2.0'
description 'Installs tcp_wrappers and configures /etc/hosts.deny, and hosts.allow'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.1'

recipe 'tcp_wrappers', 'Installs tcp_wrappers and configures /etc/hosts.allow, and hosts.deny'

%w(redhat centos fedora ubuntu debian freebsd mac_os_x oracle scientific zlinux suse opensuse opensuseleap).each do |os|
  supports os
end

source_url 'https://github.com/thomasvincent/tcp_wrappers'
issues_url 'https://github.com/thomasvincent/tcp_wrappers/issues'
chef_version '>= 12.1'
