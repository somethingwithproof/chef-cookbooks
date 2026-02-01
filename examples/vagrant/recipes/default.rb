#
# Cookbook:: vagrant_example
# Recipe:: default
#
# Copyright:: 2016-2026, Thomas Vincent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.

# Update package cache
apt_update 'update' do
  frequency 86_400
  action :periodic
end

# Install Apache
package 'apache2' do
  action :install
end

# Ensure Apache service is running and enabled
service 'apache2' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

# Create document root
directory node['vagrant_example']['apache']['docroot'] do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  recursive true
end

# Configure the default vhost
apache_vhost 'default' do
  port node['vagrant_example']['apache']['port']
  docroot node['vagrant_example']['apache']['docroot']
  server_name node['vagrant_example']['apache']['server_name']
  action :create
  only_if { node['vagrant_example']['apache']['default_site_enabled'] }
end

log 'vagrant_example' do
  message 'Apache installation and configuration complete'
  level :info
end
