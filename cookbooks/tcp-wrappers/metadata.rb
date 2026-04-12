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
version '0.5.1'

deprecated true

source_url 'https://github.com/somethingwithproof/chef-cookbooks/tree/main/cookbooks/tcp-wrappers'
issues_url 'https://github.com/somethingwithproof/chef-cookbooks/issues'

supports 'ubuntu', '>= 20.04'
supports 'debian', '>= 11.0'
supports 'redhat', '>= 8.0'
supports 'centos', '>= 8.0'
supports 'rocky', '>= 8.0'
supports 'almalinux', '>= 8.0'
supports 'oracle', '>= 8.0'
supports 'amazon', '>= 2023.0'
chef_version '>= 18.0'
