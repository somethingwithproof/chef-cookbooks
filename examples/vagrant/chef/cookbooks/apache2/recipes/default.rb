# Refactored apache2 default.rb with Chef best practices
# Cookbook:: apache2
# Recipe:: default

# Determine platform-specific defaults
package_name = node['apache']['package'] || value_for_platform_family(
  'debian' => 'apache2',
  'rhel' => 'httpd'
)

service_name = value_for_platform_family(
  'debian' => 'apache2',
  'rhel' => 'httpd'
)

web_user = value_for_platform_family('debian' => 'www-data', 'rhel' => 'apache')
index_path = value_for_platform_family(
  'debian' => '/var/www/html/index.html',
  'rhel' => '/var/www/html/index.html'
)

# Install apache2/httpd package
package package_name do
  default_release node['apache']['default_release'] if node['apache']['default_release']
end

# Ensure apache2/httpd service is enabled and started
service service_name do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

# Place default welcome/index page if not already present
cookbook_file index_path do
  source 'index.html'
  mode '0644'
  owner web_user
  group web_user
  action :create
  only_if { ::Dir.exist?(::File.dirname(index_path)) }
end

# Log the successful setup
log 'Apache installation and configuration complete.' do
  level :info
end
