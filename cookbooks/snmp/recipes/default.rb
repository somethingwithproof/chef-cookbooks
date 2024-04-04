# Cookbook Name:: snmp
# Recipe:: default
#
# Copyright 2010, Eric G. Wolfe
# Copyright 2023, Thomas Vincent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# SNMP Cookbook - Default Recipe
# Installs and configures SNMP service based on platform

# Simplified package mappings using platform_family for broader categorization
package_mappings = {
  'rhel' => {
    package: 'net-snmp',
    service: 'snmpd',
    conf_file: '/etc/snmp/snmpd.conf'
  },
  'debian' => {
    package: 'snmpd',
    service: 'snmpd',
    conf_file: '/etc/snmp/snmpd.conf'
  },
  'suse' => {
    package: 'net-snmp',
    service: 'snmpd',
    conf_file: '/etc/snmp/snmpd.conf'
  },
  'solaris2' => {
    package: 'SUNWucsnmp',
    service: 'svc:/network/snmp/dmi:default',
    conf_file: '/etc/sma/snmp/snmpd.conf'
  },
  'aix' => {
    package: 'net-snmp',
    service: 'snmpd',
    conf_file: '/etc/snmpd.conf'
  },
  'mac_os_x' => {
    package: 'net-snmp',
    service: 'org.net-snmp.snmpd',
    conf_file: '/usr/local/etc/snmp/snmpd.conf'
  }
}

# Retrieve package info based on platform_family
platform_family = node['platform_family']
package_info = package_mappings[platform_family]

# Install SNMP package
package package_info[:package]

# Configure Debian-specific default file
template '/etc/default/snmpd' do
  mode '0644'
  owner 'root'
  group 'root'
  only_if { platform_family == 'debian' }
end

# Enable and start SNMP service
service package_info[:service] do
  action [:start, :enable]
end

# Configure SNMP with platform-specific configuration file
template package_info[:conf_file] do
  mode '0600'
  owner 'root'
  group 'root'
  variables(groups: node['snmp']['groups'].keys.uniq)
  notifies :restart, "service[#{package_info[:service]}]"
end
