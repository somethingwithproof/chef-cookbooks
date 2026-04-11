# frozen_string_literal: true

#
# DEPRECATED: This cookbook is deprecated. Please use firewalld or nftables instead.
# TCP Wrappers is considered legacy technology and is no longer maintained in many modern distributions.
#
name 'tcp_wrappers'
maintainer 'Thomas Vincent'
maintainer_email 'thomasvincent@gmail.com'
license 'Apache-2.0'
description 'DEPRECATED: Installs tcp_wrappers and configures /etc/hosts.deny, and hosts.allow. Use firewalld instead.'
version '0.5.0'

deprecated true

# Supported platforms - tested with Docker/Dokken
supports 'ubuntu', '>= 22.04'
supports 'debian', '>= 12.0'
supports 'redhat', '>= 9.0'
supports 'rocky', '>= 9.0'
supports 'amazon', '>= 2023.0'

source_url 'https://github.com/thomasvincent/chef-tcp-wrappers'
issues_url 'https://github.com/thomasvincent/chef-tcp-wrappers/issues'
chef_version '>= 18.0'
