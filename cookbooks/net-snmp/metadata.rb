# frozen_string_literal: true

name 'net-snmp'
maintainer 'Thomas Vincent'
maintainer_email 'thomasvincent@github.com'
license 'Apache-2.0'
description 'Installs and configures Net-SNMP with SNMPv3 support'
version '2.0.0'
chef_version '>= 18.0'

# Platform support
supports 'ubuntu', '>= 20.04'
supports 'debian', '>= 11.0'
supports 'centos', '>= 8.0'
supports 'redhat', '>= 8.0'
supports 'amazon', '>= 2.0'
supports 'rocky', '>= 8.0'
supports 'alma', '>= 8.0'

# Dependencies
depends 'selinux', '>= 6.0'

# Source code
source_url 'https://github.com/thomasvincent/chef-net-snmp-cookbook'
issues_url 'https://github.com/thomasvincent/chef-net-snmp-cookbook/issues'
