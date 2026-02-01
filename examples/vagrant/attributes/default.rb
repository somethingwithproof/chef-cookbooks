# Cookbook:: vagrant_example
# Attributes:: default

default['vagrant_example']['apache']['port'] = 80
default['vagrant_example']['apache']['docroot'] = '/var/www/html'
default['vagrant_example']['apache']['server_name'] = node['fqdn'] || 'localhost'
default['vagrant_example']['apache']['default_site_enabled'] = true
