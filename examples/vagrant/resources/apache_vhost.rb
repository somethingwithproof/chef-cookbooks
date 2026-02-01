# Cookbook:: vagrant_example
# Resource:: apache_vhost

unified_mode true

provides :apache_vhost

description 'Manages Apache virtual host configurations'

property :site_name, String,
         name_property: true,
         description: 'The name of the virtual host site'

property :port, Integer,
         default: 80,
         description: 'The port Apache listens on for this vhost'

property :docroot, String,
         default: '/var/www/html',
         description: 'Document root directory for the vhost'

property :server_name, String,
         default: 'localhost',
         description: 'ServerName directive value'

property :server_aliases, Array,
         default: [],
         description: 'ServerAlias directive values'

action :create do
  description 'Create and enable the Apache virtual host'

  directory new_resource.docroot do
    owner 'www-data'
    group 'www-data'
    mode '0755'
    recursive true
  end

  template "/etc/apache2/sites-available/#{new_resource.site_name}.conf" do
    source 'apache_vhost.conf.erb'
    cookbook 'vagrant_example'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      port: new_resource.port,
      server_name: new_resource.server_name,
      server_aliases: new_resource.server_aliases,
      docroot: new_resource.docroot
    )
    notifies :restart, 'service[apache2]', :delayed
  end

  link "/etc/apache2/sites-enabled/#{new_resource.site_name}.conf" do
    to "/etc/apache2/sites-available/#{new_resource.site_name}.conf"
    notifies :restart, 'service[apache2]', :delayed
  end
end

action :delete do
  description 'Remove the Apache virtual host'

  link "/etc/apache2/sites-enabled/#{new_resource.site_name}.conf" do
    action :delete
    notifies :restart, 'service[apache2]', :delayed
  end

  file "/etc/apache2/sites-available/#{new_resource.site_name}.conf" do
    action :delete
  end
end
