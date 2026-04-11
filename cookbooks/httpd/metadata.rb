# frozen_string_literal: true

name 'httpd'
maintainer 'Thomas Vincent'
maintainer_email 'thomasvincent@gmail.com'
license 'Apache-2.0'
description 'Installs and configures Apache HTTP Server with advanced features'
version '1.1.0'
chef_version '>= 18.0'
source_url 'https://github.com/somethingwithproof/chef-cookbooks/tree/main/cookbooks/httpd'
issues_url 'https://github.com/somethingwithproof/chef-cookbooks/issues'

supports 'ubuntu', '>= 20.04'
supports 'debian', '>= 11.0'
supports 'redhat', '>= 8.0'
supports 'centos', '>= 8.0'
supports 'rocky', '>= 8.0'
supports 'almalinux', '>= 8.0'
supports 'oracle', '>= 8.0'
supports 'amazon', '>= 2023.0'

# BSD - Vagrant testable

# macOS - Vagrant or local testable
