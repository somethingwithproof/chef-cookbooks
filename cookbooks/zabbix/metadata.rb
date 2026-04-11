# frozen_string_literal: true

name 'zabbix'
maintainer 'Thomas Vincent'
maintainer_email 'thomasvincent@gmail.com'
license 'Apache-2.0'
description 'Installs and configures Zabbix'
version '1.0.0'
chef_version '>= 18.0'
source_url 'https://github.com/somethingwithproof/chef-cookbooks/tree/main/cookbooks/zabbix'
issues_url 'https://github.com/somethingwithproof/chef-cookbooks/issues'

supports 'ubuntu', '>= 20.04'
supports 'debian', '>= 11.0'
supports 'redhat', '>= 8.0'
supports 'centos', '>= 8.0'
supports 'rocky', '>= 8.0'
supports 'almalinux', '>= 8.0'
supports 'oracle', '>= 8.0'
supports 'amazon', '>= 2023.0'

depends 'yum-epel', '>= 4.1'
depends 'apt', '>= 7.0'
# postgresql and mysql cookbooks not used - database.rb installs packages directly
depends 'nginx', '>= 12.0'
depends 'apache2', '>= 9.0'
depends 'selinux', '>= 6.1'
