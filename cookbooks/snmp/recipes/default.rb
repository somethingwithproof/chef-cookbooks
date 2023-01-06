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

# Install required packages
case node['platform']
when 'redhat', 'centos', 'fedora', 'amazon'
  package 'net-snmp'
when 'debian', 'ubuntu'
  package 'snmpd'
when 'solaris2'
  package 'SUNWucsnmp'
when 'aix'
  package 'net-snmp'
when 'mac_os_x'
  package 'net-snmp'
end

# Configure SNMPD service
template '/etc/default/snmpd' do
  mode '0644'
  owner 'root'
  group 'root'
  only_if { node['platform_family'] == 'debian' }
end

case node['platform']
when 'redhat', 'centos', 'fedora', 'amazon'
  service_name = 'snmpd'
when 'debian', 'ubuntu'
  service_name = 'snmpd'
when 'solaris2'
  service_name = 'svc:/network/snmp/dmi:default'
when 'aix'
  service_name = 'snmpd'
when 'mac_os_x'
  service_name = 'org.net-snmp.snmpd'
end

service service_name do
  action [:start, :enable]
end

# Configure SNMPD
case node['platform']
when 'redhat', 'centos', 'fedora', 'amazon'
  conf_file = '/etc/snmp/snmpd.conf'
when 'debian', 'ubuntu'
  conf_file = '/etc/snmp/snmpd.conf'
when 'solaris2'
  conf_file = '/etc/sma/snmp/snmpd.conf'
when 'aix'
  conf_file = '/etc/snmpd.conf'
when 'mac_os_x'
  conf_file = '/usr/local/etc/snmp/snmpd.conf'
end

template conf_file do
  mode '0600'
  owner 'root'
  group 'root'
  variables(groups: node['snmp']['groups'].keys.uniq)
  notifies :restart, "service[#{service_name}]"
end
