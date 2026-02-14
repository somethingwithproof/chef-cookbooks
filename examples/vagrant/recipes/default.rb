#
# Cookbook:: vagrant_example
# Recipe:: default
#
# Copyright:: 2016-2026, Thomas Vincent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.

# Platform-specific settings
case node['platform_family']
when 'debian'
  package_name = 'apache2'
  service_name = 'apache2'
  apache_user = 'www-data'
  apache_group = 'www-data'
  config_dir = '/etc/apache2'
  sites_available = "#{config_dir}/sites-available"
  sites_enabled = "#{config_dir}/sites-enabled"
when 'rhel', 'fedora', 'amazon'
  package_name = 'httpd'
  service_name = 'httpd'
  apache_user = 'apache'
  apache_group = 'apache'
  config_dir = '/etc/httpd'
  sites_available = "#{config_dir}/conf.d"
  sites_enabled = "#{config_dir}/conf.d"
else
  raise "Unsupported platform family: #{node['platform_family']}"
end

# Update package cache (Debian/Ubuntu only)
if platform_family?('debian')
  apt_update 'update' do
    frequency 86_400
    action :periodic
  end
end

# Install Apache
package package_name do
  action :install
end

# Ensure Apache service is running and enabled
service service_name do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

# Create document root
directory node['vagrant_example']['apache']['docroot'] do
  owner apache_user
  group apache_group
  mode '0755'
  recursive true
end

# Configure the default vhost
apache_vhost 'default' do
  port node['vagrant_example']['apache']['port']
  docroot node['vagrant_example']['apache']['docroot']
  server_name node['vagrant_example']['apache']['server_name']
  config_dir config_dir
  sites_available sites_available
  sites_enabled sites_enabled
  apache_user apache_user
  apache_group apache_group
  service_name service_name
  action :create
  only_if { node['vagrant_example']['apache']['default_site_enabled'] }
end

log 'vagrant_example' do
  message 'Apache installation and configuration complete'
  level :info
end
