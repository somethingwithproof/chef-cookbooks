# frozen_string_literal: true

#
# Cookbook:: net-snmp
# Attributes:: default
#
# Copyright:: 2025, Thomas Vincent
# License:: Apache-2.0
#

# Package names by platform
default['net_snmp']['packages'] = case node['platform_family']
                                  when 'rhel', 'fedora', 'amazon'
                                    %w[net-snmp net-snmp-utils]
                                  when 'debian'
                                    %w[snmp snmpd snmp-mibs-downloader]
                                  else
                                    %w[net-snmp]
                                  end

# Service configuration
default['net_snmp']['service_name'] = 'snmpd'
default['net_snmp']['service_actions'] = %i[enable start]

# Configuration file paths
default['net_snmp']['config_dir'] = '/etc/snmp'
default['net_snmp']['config_file'] = '/etc/snmp/snmpd.conf'
default['net_snmp']['config_include_dir'] = '/etc/snmp/snmpd.conf.d'

# System information
default['net_snmp']['sys_location'] = 'Unknown'
default['net_snmp']['sys_contact'] = 'root@localhost'
default['net_snmp']['sys_name'] = node['hostname']

# Network configuration
default['net_snmp']['listen_address'] = 'udp:161,udp6:[::1]:161'

# SNMPv2c community strings (INSECURE - use SNMPv3 for production)
# Example: [{ community: 'public', access: 'rocommunity', source: '127.0.0.1', view: 'systemview' }]
default['net_snmp']['community_strings'] = []

# SNMPv3 users (RECOMMENDED for production)
# Example:
# default['net_snmp']['v3_users'] = [
#   {
#     username: 'monitoring',
#     auth_protocol: 'SHA-256',
#     auth_password: 'secure_auth_password_here',
#     priv_protocol: 'AES-256',
#     priv_password: 'secure_priv_password_here',
#     security_level: 'authPriv',
#     access_level: 'ro',
#     view: 'systemview'
#   }
# ]
default['net_snmp']['v3_users'] = []

# View definitions
default['net_snmp']['views'] = [
  { name: 'systemview', type: 'included', oid: '.1.3.6.1.2.1.1' },  # System MIB
  { name: 'systemview', type: 'included', oid: '.1.3.6.1.2.1.25.1' }, # Host resources
  { name: 'systemview', type: 'included', oid: '.1.3.6.1.4.1.2021' }, # UCD-SNMP-MIB (disk, memory, cpu)
  { name: 'allview', type: 'included', oid: '.1' }
]

# Disk monitoring
# Example: ['/', '/var', '/home'] or [{ path: '/', min_percent: 10 }]
default['net_snmp']['disk_monitoring'] = []

# Load average thresholds
default['net_snmp']['load_thresholds'] = {
  '1min' => 12,
  '5min' => 10,
  '15min' => 5
}

# Extend scripts for custom monitoring
# Example: [{ name: 'disk_check', command: '/usr/local/bin/check_disk.sh' }]
default['net_snmp']['extend_scripts'] = []

# Security settings
default['net_snmp']['disable_snmpv1'] = true
default['net_snmp']['disable_snmpv2c'] = false  # Set to true for maximum security

# SELinux settings (RHEL/CentOS/Rocky/Alma)
default['net_snmp']['selinux']['enabled'] = true
default['net_snmp']['selinux']['ports'] = [161, 162]
