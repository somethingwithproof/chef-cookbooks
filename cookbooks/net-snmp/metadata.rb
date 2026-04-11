# frozen_string_literal: true

name 'net-snmp'
maintainer 'Thomas Vincent'
maintainer_email 'thomasvincent@github.com'
license 'Apache-2.0'
description 'Installs and configures Net-SNMP with SNMPv3 support'
version '2.1.0'
chef_version '>= 18.0'

# Supported platforms
supports 'ubuntu', '>= 20.04'
supports 'debian', '>= 11.0'
supports 'redhat', '>= 8.0'
supports 'centos', '>= 8.0'
supports 'rocky', '>= 8.0'
supports 'almalinux', '>= 8.0'
supports 'oracle', '>= 8.0'
supports 'amazon', '>= 2023.0'

source_url 'https://github.com/somethingwithproof/chef-cookbooks/tree/main/cookbooks/net-snmp'
issues_url 'https://github.com/somethingwithproof/chef-cookbooks/issues'
