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
                                    %w(net-snmp net-snmp-utils)
                                  when 'debian'
                                    %w(snmp snmpd snmp-mibs-downloader)
                                  when 'freebsd'
                                    %w(net-snmp)
                                  when 'mac_os_x'
                                    %w(net-snmp)
                                  else
                                    %w(net-snmp)
                                  end

# Service configuration
default['net_snmp']['service_name'] = case node['platform_family']
                                      when 'freebsd'
                                        'snmpd'
                                      when 'mac_os_x'
                                        'net-snmp'
                                      else
                                        'snmpd'
                                      end
default['net_snmp']['service_actions'] = %i(enable start)

# Configuration file paths
default['net_snmp']['config_dir'] = case node['platform_family']
                                    when 'freebsd'
                                      '/usr/local/etc/snmp'
                                    when 'mac_os_x'
                                      '/opt/homebrew/etc'
                                    else
                                      '/etc/snmp'
                                    end
default['net_snmp']['config_file'] = case node['platform_family']
                                     when 'freebsd'
                                       '/usr/local/etc/snmp/snmpd.conf'
                                     when 'mac_os_x'
                                       '/opt/homebrew/etc/snmpd.conf'
                                     else
                                       '/etc/snmp/snmpd.conf'
                                     end
default['net_snmp']['config_include_dir'] = case node['platform_family']
                                            when 'freebsd'
                                              '/usr/local/etc/snmp/snmpd.conf.d'
                                            when 'mac_os_x'
                                              '/opt/homebrew/etc/snmpd.conf.d'
                                            else
                                              '/etc/snmp/snmpd.conf.d'
                                            end

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
  { name: 'systemview', type: 'included', oid: '.1.3.6.1.2.1.1' }, # System MIB
  { name: 'systemview', type: 'included', oid: '.1.3.6.1.2.1.25.1' }, # Host resources
  { name: 'systemview', type: 'included', oid: '.1.3.6.1.4.1.2021' }, # UCD-SNMP-MIB (disk, memory, cpu)
  { name: 'allview', type: 'included', oid: '.1' },
]

# Disk monitoring
# Example: ['/', '/var', '/home'] or [{ path: '/', min_percent: 10 }]
default['net_snmp']['disk_monitoring'] = []

# Load average thresholds
default['net_snmp']['load_thresholds'] = {
  '1min' => 12,
  '5min' => 10,
  '15min' => 5,
}

# Extend scripts for custom monitoring
# Example: [{ name: 'disk_check', command: '/usr/local/bin/check_disk.sh' }]
default['net_snmp']['extend_scripts'] = []

# Pass scripts for OID-based command execution
# Example: [{ oid: '.1.3.6.1.4.1.2021.255', command: '/usr/local/bin/custom_oid.sh' }]
default['net_snmp']['pass_scripts'] = []

# Group definitions for access control
# Example: [{ name: 'v3group', model: 'usm', security_name: 'monitoring' }]
default['net_snmp']['groups'] = []

# Access rules for groups
# Example: [{ group: 'v3group', level: 'authPriv', read_view: 'systemview', write_view: 'none', notify_view: 'none' }]
default['net_snmp']['access_rules'] = []

# Security settings
default['net_snmp']['disable_snmpv1'] = true
# WARNING: SNMPv2c uses cleartext community strings and is insecure.
# Set disable_snmpv2c to true and use SNMPv3 for production environments.
# SNMPv2c should only be used for compatibility with legacy systems on trusted networks.
default['net_snmp']['disable_snmpv2c'] = false # Set to true for maximum security

# SELinux settings (RHEL/CentOS/Rocky/Alma)
default['net_snmp']['selinux']['enabled'] = true
default['net_snmp']['selinux']['ports'] = [161, 162]

# -----------------------------------------------------------------------------
# SNMP Trap Daemon (snmptrapd) Configuration
# -----------------------------------------------------------------------------

# Enable snmptrapd service
default['net_snmp']['trapd']['enabled'] = false

# Listen address for trap receiver
default['net_snmp']['trapd']['listen_address'] = 'udp:162'

# Community string for v1/v2c traps (insecure - use v3 for production)
default['net_snmp']['trapd']['community'] = nil

# SNMPv3 users for trap authentication
# Example:
# default['net_snmp']['trapd']['v3_users'] = [
#   {
#     username: 'trapuser',
#     engine_id: '0x80001f8880',
#     auth_protocol: 'SHA',
#     auth_password: 'auth_password_here',
#     priv_protocol: 'AES',
#     priv_password: 'priv_password_here'
#   }
# ]
default['net_snmp']['trapd']['v3_users'] = []

# How to handle received traps: 'syslog', 'file', or 'execute'
default['net_snmp']['trapd']['log_type'] = 'syslog'

# Log file path when log_type is 'file'
default['net_snmp']['trapd']['log_file'] = '/var/log/snmptrapd.log'

# Custom trap handler script path when log_type is 'execute'
default['net_snmp']['trapd']['handler'] = nil

# Addresses to forward traps to
# Example: ['192.168.1.10:162', 'udp:192.168.1.11:162']
default['net_snmp']['trapd']['forward_addresses'] = []

# Require authentication for traps
default['net_snmp']['trapd']['auth_required'] = true

# Custom trap handlers array for specific OID-based handling
# Example:
# default['net_snmp']['trapd']['handlers'] = [
#   {
#     name: 'disk_alert',
#     oid_filter: '.1.3.6.1.4.1.2021',
#     action: 'email',
#     email_to: 'ops@example.com'
#   },
#   {
#     name: 'webhook_handler',
#     action: 'webhook',
#     webhook_url: 'https://hooks.example.com/snmp'
#   }
# ]
default['net_snmp']['trapd']['handlers'] = []

# -----------------------------------------------------------------------------
# Prometheus SNMP Exporter Configuration
# -----------------------------------------------------------------------------

# Enable Prometheus SNMP exporter
default['net_snmp']['prometheus']['enabled'] = false

# SNMP exporter version
default['net_snmp']['prometheus']['exporter_version'] = '0.26.0'

# Download checksum (optional - for verification)
default['net_snmp']['prometheus']['checksum'] = nil

# Exporter listen port
default['net_snmp']['prometheus']['port'] = 9116

# Service user and group
default['net_snmp']['prometheus']['user'] = 'snmp_exporter'
default['net_snmp']['prometheus']['group'] = 'snmp_exporter'

# SNMP modules configuration
# This defines which OIDs to walk/get and how to expose them as metrics
# Example:
# default['net_snmp']['prometheus']['modules'] = {
#   'if_mib' => {
#     'walk' => ['1.3.6.1.2.1.2', '1.3.6.1.2.1.31.1.1'],
#     'version' => 2,
#     'auth' => {
#       'community' => 'public'
#     },
#     'metrics' => [
#       {
#         'name' => 'ifNumber',
#         'oid' => '1.3.6.1.2.1.2.1',
#         'type' => 'gauge',
#         'help' => 'Number of network interfaces'
#       }
#     ]
#   }
# }
default['net_snmp']['prometheus']['modules'] = {
  'default' => {
    'walk' => [
      '1.3.6.1.2.1.1',        # System MIB
      '1.3.6.1.2.1.2',        # Interfaces
      '1.3.6.1.2.1.25.1',     # Host resources
      '1.3.6.1.4.1.2021', # UCD-SNMP-MIB
    ],
    'version' => 2,
    'auth' => {
      # WARNING: Set a secure community string or use SNMPv3 for production
      'community' => nil,
    },
    'metrics' => [
      {
        'name' => 'sysUpTime',
        'oid' => '1.3.6.1.2.1.1.3',
        'type' => 'gauge',
        'help' => 'System uptime in hundredths of a second',
      },
      {
        'name' => 'ifNumber',
        'oid' => '1.3.6.1.2.1.2.1',
        'type' => 'gauge',
        'help' => 'Number of network interfaces',
      },
    ],
  },
}

# -----------------------------------------------------------------------------
# MIB Management Configuration
# -----------------------------------------------------------------------------

# Enable MIB downloads
default['net_snmp']['mibs']['enabled'] = true

# MIB directories
default['net_snmp']['mibs']['directories'] = case node['platform_family']
                                             when 'freebsd'
                                               ['/usr/local/share/snmp/mibs']
                                             when 'mac_os_x'
                                               ['/opt/homebrew/share/snmp/mibs']
                                             else
                                               ['/usr/share/snmp/mibs', '/var/lib/snmp/mibs']
                                             end

# Custom MIBs to install (URL or local path)
# Example: [{ name: 'VENDOR-MIB', source: 'https://example.com/VENDOR-MIB.txt' }]
default['net_snmp']['mibs']['custom'] = []
