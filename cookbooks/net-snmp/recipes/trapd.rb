# frozen_string_literal: true

#
# Cookbook:: net-snmp
# Recipe:: trapd
#
# Copyright:: 2025-2026, Thomas Vincent
# License:: Apache-2.0
#

# Configure SNMP trap receiver (snmptrapd)

snmp_trap_receiver 'default' do
  listen_address node['net_snmp']['trapd']['listen_address']
  community node['net_snmp']['trapd']['community'] if node['net_snmp']['trapd']['community']
  v3_users node['net_snmp']['trapd']['v3_users']
  log_type node['net_snmp']['trapd']['log_type']
  log_file node['net_snmp']['trapd']['log_file']
  trap_handler node['net_snmp']['trapd']['handler'] if node['net_snmp']['trapd']['handler']
  forward_addresses node['net_snmp']['trapd']['forward_addresses']
  auth_required node['net_snmp']['trapd']['auth_required']
  action [:create, :enable]
end

# Create log directory if file logging is used
if node['net_snmp']['trapd']['log_type'] == 'file'
  directory ::File.dirname(node['net_snmp']['trapd']['log_file']) do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
  end
end

# Create handler script directory
directory '/usr/local/bin/snmp-handlers' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  only_if { node['net_snmp']['trapd']['handlers'] && !node['net_snmp']['trapd']['handlers'].empty? }
end

# Deploy custom trap handlers from attributes
node['net_snmp']['trapd']['handlers']&.each do |handler|
  template "/usr/local/bin/snmp-handlers/#{handler['name']}.sh" do
    source 'trap_handler.sh.erb'
    cookbook 'net-snmp'
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      name: handler['name'],
      action: handler['action'],
      oid_filter: handler['oid_filter'],
      email_to: handler['email_to'],
      webhook_url: handler['webhook_url'],
      log_file: handler['log_file']
    )
  end
end
