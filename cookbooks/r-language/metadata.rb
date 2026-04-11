name 'r-language'
maintainer 'Thomas Vincent'
maintainer_email 'thomasvincent@github.com'
license 'MIT'
description 'Installs/Configures R programming language'
version '1.0.0'
chef_version '>= 18.0'

depends 'build-essential', '>= 8.0'

# Current non-EOL platforms as of May 2025
supports 'amazon', '>= 2.0'
supports 'debian', '>= 10.0'
supports 'ubuntu', '>= 18.04'
supports 'redhat', '>= 7.0'
supports 'rocky', '>= 8.0'
supports 'oracle', '>= 7.0'

source_url 'https://github.com/somethingwithproof/chef-cookbooks/tree/main/cookbooks/r-language'
issues_url 'https://github.com/somethingwithproof/chef-cookbooks/issues'
