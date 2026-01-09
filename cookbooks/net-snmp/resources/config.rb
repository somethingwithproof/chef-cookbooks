# frozen_string_literal: true

#
# Cookbook:: net-snmp
# Resource:: config
#
# Copyright:: 2025, Thomas Vincent
# License:: Apache-2.0
#
# Custom resource for managing SNMP daemon configuration.
#

unified_mode true

provides :snmp_config

property :config_file, String,
         default: '/etc/snmp/snmpd.conf',
         description: 'Path to the snmpd configuration file'

property :sys_location, String,
         default: 'Unknown',
         description: 'System location for SNMP sysLocation'

property :sys_contact, String,
         default: 'root@localhost',
         description: 'System contact for SNMP sysContact'

property :sys_name, String,
         default: lazy { node['hostname'] },
         description: 'System name for SNMP sysName'

property :listen_address, String,
         default: 'udp:161',
         description: 'Address and port for SNMP daemon to listen on'

property :community_strings, Array,
         default: [],
         description: 'Array of community string configurations (SNMPv2c)'

property :views, Array,
         default: [{ name: 'systemview', type: 'included', oid: '.1.3.6.1.2.1' }],
         description: 'Array of view definitions'

property :groups, Array,
         default: [],
         description: 'Array of group definitions for access control'

property :access_rules, Array,
         default: [],
         description: 'Array of access rules'

property :disk_monitoring, Array,
         default: [],
         description: 'Array of disk paths to monitor (e.g., ["/", "/var"])'

property :load_thresholds, Hash,
         default: { '1min' => 12, '5min' => 10, '15min' => 5 },
         description: 'Load average thresholds'

property :extend_scripts, Array,
         default: [],
         description: 'Array of extend script definitions'

property :pass_scripts, Array,
         default: [],
         description: 'Array of pass script definitions'

property :owner, String,
         default: 'root',
         description: 'Owner of the configuration file'

property :group, String,
         default: lazy { platform_family?('debian') ? 'root' : 'root' },
         description: 'Group of the configuration file'

property :mode, String,
         default: '0600',
         description: 'File mode (restrictive by default for security)'

action :create do
  # Ensure directory exists
  directory ::File.dirname(new_resource.config_file) do
    owner new_resource.owner
    group new_resource.group
    mode '0755'
    recursive true
  end

  # Create configuration file from template
  template new_resource.config_file do
    source 'snmpd.conf.erb'
    cookbook 'net-snmp'
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    sensitive true
    variables(
      sys_location: new_resource.sys_location,
      sys_contact: new_resource.sys_contact,
      sys_name: new_resource.sys_name,
      listen_address: new_resource.listen_address,
      community_strings: new_resource.community_strings,
      views: new_resource.views,
      groups: new_resource.groups,
      access_rules: new_resource.access_rules,
      disk_monitoring: new_resource.disk_monitoring,
      load_thresholds: new_resource.load_thresholds,
      extend_scripts: new_resource.extend_scripts,
      pass_scripts: new_resource.pass_scripts
    )
    notifies :restart, 'service[snmpd]', :delayed
  end
end

action :delete do
  file new_resource.config_file do
    action :delete
  end
end
