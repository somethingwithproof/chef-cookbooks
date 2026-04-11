# frozen_string_literal: true

name 'net-snmp'
maintainer 'Thomas Vincent'
maintainer_email 'thomasvincent@github.com'
license 'Apache-2.0'
description 'Installs and configures Net-SNMP with SNMPv3 support'
version '2.0.0'
chef_version '>= 18.0'

# Supported platforms as of January 2026
# Linux - Docker/Dokken testable
supports 'ubuntu', '>= 22.04'
supports 'debian', '>= 12.0'
supports 'redhat', '>= 9.0'
supports 'rocky', '>= 9.0'
supports 'almalinux', '>= 9.0'
supports 'amazon', '>= 2023.0'

# BSD - Vagrant testable
supports 'freebsd', '>= 14.0'

# macOS - Vagrant or local testable
supports 'mac_os_x', '>= 13.0'

# Source code
source_url 'https://github.com/somethingwithproof/chef-cookbooks/tree/main/cookbooks/net-snmp'
issues_url 'https://github.com/somethingwithproof/chef-cookbooks/issues'
