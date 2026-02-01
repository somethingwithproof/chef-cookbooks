# frozen_string_literal: true

#
# Cookbook:: net-snmp
# Resource:: user
#
# Copyright:: 2025, Thomas Vincent
# License:: Apache-2.0
#
# Custom resource for managing SNMPv3 users with authentication and privacy.
#

unified_mode true

provides :snmp_user

property :username, String,
         name_property: true,
         description: 'SNMPv3 username'

property :auth_protocol, String,
         equal_to: %w(MD5 SHA SHA-224 SHA-256 SHA-384 SHA-512),
         default: 'SHA-256',
         description: 'Authentication protocol (SHA-256 recommended)'

property :auth_password, String,
         required: true,
         sensitive: true,
         description: 'Authentication password (minimum 8 characters)'

property :priv_protocol, String,
         equal_to: %w(DES AES AES-128 AES-192 AES-256),
         default: 'AES-256',
         description: 'Privacy/encryption protocol (AES-256 recommended)'

property :priv_password, String,
         sensitive: true,
         description: 'Privacy password (defaults to auth_password if not set)'

property :security_level, String,
         equal_to: %w(noAuthNoPriv authNoPriv authPriv),
         default: 'authPriv',
         description: 'Security level (authPriv recommended for production)'

property :access_level, String,
         equal_to: %w(ro rw),
         default: 'ro',
         description: 'Access level (read-only or read-write)'

property :view, String,
         default: 'systemview',
         description: 'View to grant access to'

property :source_network, String,
         default: 'default',
         description: 'Source network restriction (CIDR or "default")'

property :user_file, String,
         default: '/var/lib/snmp/snmpd.conf',
         description: 'Path to the persistent user storage file'

action :create do
  # Validate password length
  if new_resource.auth_password.length < 8
    raise "SNMPv3 auth_password must be at least 8 characters for user #{new_resource.username}"
  end

  priv_pass = new_resource.priv_password || new_resource.auth_password

  # Map protocol names to net-snmp format
  auth_proto = case new_resource.auth_protocol
               when 'SHA-256' then 'SHA-256'
               when 'SHA-384' then 'SHA-384'
               when 'SHA-512' then 'SHA-512'
               else new_resource.auth_protocol
               end

  priv_proto = case new_resource.priv_protocol
               when 'AES-256' then 'AES256'
               when 'AES-192' then 'AES192'
               when 'AES-128', 'AES' then 'AES'
               else new_resource.priv_protocol
               end

  # Create the user using net-snmp-create-v3-user or manual configuration
  execute "create_snmpv3_user_#{new_resource.username}" do
    command lazy {
      cmd = "net-snmp-create-v3-user -ro -A '#{new_resource.auth_password}' -a #{auth_proto}"
      cmd += " -X '#{priv_pass}' -x #{priv_proto}" if new_resource.security_level == 'authPriv'
      cmd += " #{new_resource.username}"
      cmd
    }
    sensitive true
    not_if { ::File.exist?(new_resource.user_file) && ::File.read(new_resource.user_file).include?("usmUser.*#{new_resource.username}") }
    notifies :restart, 'service[snmpd]', :delayed
  end

  # Add user access configuration to snmpd.conf
  file "/etc/snmp/snmpd.conf.d/#{new_resource.username}.conf" do
    content <<~CONF
      # SNMPv3 user: #{new_resource.username}
      # Security level: #{new_resource.security_level}
      rouser #{new_resource.username} #{new_resource.security_level} -V #{new_resource.view}
    CONF
    owner 'root'
    group 'root'
    mode '0600'
    sensitive true
    notifies :restart, 'service[snmpd]', :delayed
    only_if { ::Dir.exist?('/etc/snmp/snmpd.conf.d') }
  end
end

action :delete do
  # Remove user configuration
  file "/etc/snmp/snmpd.conf.d/#{new_resource.username}.conf" do
    action :delete
    notifies :restart, 'service[snmpd]', :delayed
  end

  # NOTE: Removing from persistent storage requires service restart
  log "SNMPv3 user #{new_resource.username} configuration removed. Restart snmpd to complete removal." do
    level :info
  end
end
