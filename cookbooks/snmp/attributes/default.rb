# Cookbook Name:: snmp
# Attributes:: default
#
# Copyright 2010, Eric G. Wolfe
# Copyright 2023, Thomas Vincent
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default['snmp']['packages'] =
  case node['platform_family']
  when 'rhel', 'fedora', 'amazon'
    %w(net-snmp net-snmp-utils)
  when 'debian', 'ubuntu'
    %w(snmp snmpd)
  when 'suse', 'opensuse'
    %w(net-snmp)
  when 'freebsd'
    %w(net-snmp)
  when 'mac_os_x', 'mac_os_x_server'
    %w(net-snmp)
  when 'solaris2'
    %w(SUNWucsnmp)
  when 'aix'
    %w(net-snmp)
  else
    %w(net-snmp net-snmp-utils)
  end

default['snmp']['service'] =
  case node['platform_family']
  when 'rhel', 'fedora', 'amazon', 'debian', 'ubuntu', 'suse', 'opensuse', 'freebsd', 'mac_os_x', 'mac_os_x_server', 'aix'
    'snmpd'
  when 'solaris2'
    'svc:/network/snmp/dmi:default'
  end

default['snmp']['community'] = 'public'
default['snmp']['sec_name'] = { 'notConfigUser' => %w(default) }
default['snmp']['sec_name6'] = { 'notConfigUser' => %w(default) }

default['snmp']['groups'] = {
  'v1' => { 'notConfigGroup' => %w(notConfigUser) },
  'v2c' => { 'notConfigGroup' => %w(notConfigUser) }
}

default['snmp']['trap']['community'] = 'public'
default['snmp']['trap']['addresses'] = []
default['snmp']['trap']['port'] = 162
