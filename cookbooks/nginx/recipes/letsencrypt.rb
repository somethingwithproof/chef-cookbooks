# frozen_string_literal: true

#
# Cookbook:: nginx
# Recipe:: letsencrypt
#
# Copyright:: 2023-2026, Thomas Vincent
# License:: Apache-2.0
#

# Install certbot and nginx plugin
case node['platform_family']
when 'debian'
  package %w(certbot python3-certbot-nginx) do
    action :install
  end
when 'rhel', 'fedora', 'amazon'
  include_recipe 'yum-epel::default' if platform_family?('rhel')

  package %w(certbot python3-certbot-nginx) do
    action :install
  end
end

# Ensure webroot exists for ACME challenges
directory node['nginx']['letsencrypt']['webroot'] do
  recursive true
  mode '0755'
end

# Create ACME challenge directory
directory "#{node['nginx']['letsencrypt']['webroot']}/.well-known/acme-challenge" do
  recursive true
  mode '0755'
end

# Configure nginx for ACME challenges
template "#{node['nginx']['conf_dir']}/conf.d/letsencrypt.conf" do
  source 'letsencrypt.conf.erb'
  cookbook 'nginx'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    webroot: node['nginx']['letsencrypt']['webroot']
  )
  notifies :reload, 'service[nginx]', :delayed
end

# Automatic renewal via systemd timer (certbot ships the unit)
service 'certbot.timer' do
  action %i(enable start)
  only_if { ::File.exist?('/lib/systemd/system/certbot.timer') }
end

directory '/etc/letsencrypt/renewal-hooks/deploy' do
  recursive true
  mode '0755'
end

file '/etc/letsencrypt/renewal-hooks/deploy/01-nginx-reload' do
  content <<~SCRIPT
    #!/bin/bash
    /bin/systemctl reload nginx.service
  SCRIPT
  mode '0755'
end

# Request certificates for configured domains
node['nginx']['letsencrypt']['domains'].each do |domain_config|
  nginx_certificate domain_config['domain'] do
    alt_names domain_config['alt_names'] || []
    email domain_config['email'] || node['nginx']['letsencrypt']['email']
    webroot node['nginx']['letsencrypt']['webroot']
    staging node['nginx']['letsencrypt']['staging']
    provider 'letsencrypt'
    action :create
    only_if { domain_config['enabled'] != false }
  end
end
