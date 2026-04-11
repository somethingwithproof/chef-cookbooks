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

property :config_dir, String,
         required: true,
         description: 'Apache configuration directory'

property :sites_available, String,
         required: true,
         description: 'Sites available directory'

property :sites_enabled, String,
         required: true,
         description: 'Sites enabled directory'

property :apache_user, String,
         required: true,
         description: 'Apache user'

property :apache_group, String,
         required: true,
         description: 'Apache group'

property :service_name, String,
         required: true,
         description: 'Apache service name'

action :create do
  description 'Create and enable the Apache virtual host'

  directory new_resource.docroot do
    owner new_resource.apache_user
    group new_resource.apache_group
    mode '0755'
    recursive true
  end

  # Apache vhost configuration (contains development-only security settings)
  template "#{new_resource.sites_available}/#{new_resource.site_name}.conf" do
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
    notifies :restart, "service[#{new_resource.service_name}]", :delayed
  end

  # Only create symlink for Debian-based systems (RHEL uses single directory)
  if new_resource.sites_available != new_resource.sites_enabled
    link "#{new_resource.sites_enabled}/#{new_resource.site_name}.conf" do
      to "#{new_resource.sites_available}/#{new_resource.site_name}.conf"
      notifies :restart, "service[#{new_resource.service_name}]", :delayed
    end
  end
end

action :delete do
  description 'Remove the Apache virtual host'

  if new_resource.sites_available != new_resource.sites_enabled
    link "#{new_resource.sites_enabled}/#{new_resource.site_name}.conf" do
      action :delete
      notifies :restart, "service[#{new_resource.service_name}]", :delayed
    end
  end

  file "#{new_resource.sites_available}/#{new_resource.site_name}.conf" do
    action :delete
  end
end
