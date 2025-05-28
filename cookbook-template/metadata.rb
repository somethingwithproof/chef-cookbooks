# frozen_string_literal: true

name 'cookbook-template'
maintainer 'Thomas Vincent'
maintainer_email 'thomasvincent@gmail.com'
license 'Apache-2.0'
description 'Modern Chef cookbook template with best practices for Chef 19+'
version '1.0.0'
chef_version '>= 18.0'

# Platform support
supports 'ubuntu', '>= 22.04'
supports 'debian', '>= 12.0'
supports 'rocky', '>= 9.0'
supports 'amazon', '>= 2023.0'

# Source code
source_url 'https://github.com/thomasvincent/chef-cookbook-template'
issues_url 'https://github.com/thomasvincent/chef-cookbook-template/issues'

# Gem dependencies for functionality (if needed)
# gem 'net-ssh', '~> 7.0'
