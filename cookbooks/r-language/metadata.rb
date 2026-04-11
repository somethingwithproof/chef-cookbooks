name 'r-language'
maintainer 'Thomas Vincent'
maintainer_email 'thomasvincent@github.com'
license 'MIT'
description 'Installs/Configures R programming language'
version '1.1.0'
chef_version '>= 18.0'

depends 'build-essential', '>= 8.0'

# Current non-EOL platforms as of May 2025

source_url 'https://github.com/somethingwithproof/chef-cookbooks/tree/main/cookbooks/r-language'
issues_url 'https://github.com/somethingwithproof/chef-cookbooks/issues'

supports 'ubuntu', '>= 20.04'
supports 'debian', '>= 11.0'
supports 'redhat', '>= 8.0'
supports 'centos', '>= 8.0'
supports 'rocky', '>= 8.0'
supports 'almalinux', '>= 8.0'
supports 'oracle', '>= 8.0'
supports 'amazon', '>= 2023.0'
