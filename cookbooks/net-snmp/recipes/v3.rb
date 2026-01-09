# frozen_string_literal: true

#
# Cookbook:: net-snmp
# Recipe:: v3
#
# Copyright:: 2025, Thomas Vincent
# License:: Apache-2.0
#
# This recipe configures SNMPv3 with authentication and encryption.
# SNMPv3 is recommended for production environments as it provides:
# - User-based authentication (USM)
# - Message integrity
# - Encryption (privacy)
#

# Include base installation
include_recipe 'net-snmp::default'

# Create configuration include directory
directory node['net_snmp']['config_include_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
end

# Configure SNMPv3 users
node['net_snmp']['v3_users'].each do |user_config|
  snmp_user user_config['username'] do
    auth_protocol user_config['auth_protocol'] || 'SHA-256'
    auth_password user_config['auth_password']
    priv_protocol user_config['priv_protocol'] || 'AES-256'
    priv_password user_config['priv_password']
    security_level user_config['security_level'] || 'authPriv'
    access_level user_config['access_level'] || 'ro'
    view user_config['view'] || 'systemview'
    action :create
  end
end

log 'SNMPv3 configuration complete' do
  message "Configured #{node['net_snmp']['v3_users'].length} SNMPv3 user(s)"
  level :info
end
