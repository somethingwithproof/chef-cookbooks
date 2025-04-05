# Cookbook:: apache2
# Recipe:: default

# Install apache2 package
package node['apache']['package'] do
  default_release node['apache']['default_release'] if node['apache']['default_release']
end

# Create required Apache configuration directories
%w[
  sites-available
  sites-enabled
  mods-available
  mods-enabled
  conf-available
  conf-enabled
].each do |dir|
  directory ::File.join(node['apache']['dir'], dir) do
    mode '0755'
    recursive true
    action :create
  end
end

# Ensure apache2 service is enabled and started
service 'apache2' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

# Place default welcome/index page
cookbook_file '/var/www/html/index.html' do
  source 'index.html'
  mode '0644'
  owner 'www-data'
  group 'www-data'
  action :create
end

# Log the successful setup
log 'Apache2 installation and setup completed.' do
  level :info
end
