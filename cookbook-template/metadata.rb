# frozen_string_literal: true

name 'cookbook-template'
maintainer 'Thomas Vincent'
maintainer_email 'thomasvincent@gmail.com'
license 'Apache-2.0'
description 'Modern Chef cookbook template with best practices for Chef 19+'
version '1.0.0'
chef_version '>= 19.0'

# Platform support
supports 'ubuntu', '>= 20.04'
supports 'debian', '>= 10.0'
supports 'centos', '>= 7.0'
supports 'rocky', '>= 8.0'
supports 'amazonlinux', '>= 2.0'
supports 'opensuseleap', '>= 15.0'

# Source code
source_url 'https://github.com/thomasvincent/chef-cookbook-template'
issues_url 'https://github.com/thomasvincent/chef-cookbook-template/issues'

# Gem dependencies for functionality (if needed)
# gem 'net-ssh', '~> 7.0'