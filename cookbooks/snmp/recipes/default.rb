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

package_mappings = {
  redhat: {
    package: 'net-snmp',
    service: 'snmpd',
    conf_file: '/etc/snmp/snmpd.conf'
  },
  centos: {
    package: 'net-snmp',
    service: 'snmpd',
    conf_file: '/etc/snmp/snmpd.conf'
  },
  fedora: {
    package: 'net-snmp',
    service: 'snmpd',
    conf_file: '/etc/snmp/snmpd.conf'
  },
  amazon: {
    package: 'net-snmp',
    service: 'snmpd',
    conf_file: '/etc/snmp/snmpd.conf'
  },
  debian: {
    package: 'snmpd',
    service: 'snmpd',
    conf_file: '/etc/snmp/snmpd.conf'
  },
  ubuntu: {
    package: 'snmpd',
    service: 'snmpd',
    conf_file: '/etc/snmp/snmpd.conf'
  },
  solaris2: {
    package: 'SUNWucsnmp',
    service: 'svc:/network/snmp/dmi:default',
    conf_file: '/etc/sma/snmp/snmpd.conf'
  },
  aix: {
    package: 'net-snmp',
    service: 'snmpd',
    conf_file: '/etc/snmpd.conf'
  },
  mac_os_x: {
    package: 'net-snmp',
    service: 'org.net-snmp.snmpd',
    conf_file: '/usr/local/etc/snmp/snmpd.conf'
  }
}

platform = node['platform'].to_sym
package_info = package_mappings[platform]

package package_info[:package]

template '/etc/default/snmpd' do
  mode '0644'
  owner 'root'
  group 'root'
  only_if { node['platform_family'] == 'debian' }
end

service package_info[:service] do
  action [:start, :enable]
end

template package_info[:conf_file] do
  mode '0600'
  owner 'root'
  group 'root'
  variables(groups: node['snmp']['groups'].keys.uniq)
  notifies :restart, "service[#{package_info[:service]}]"
end
