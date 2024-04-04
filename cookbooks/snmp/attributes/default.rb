# Cookbook Name:: snmp
# Attributes:: default
#
# Copyright 2010, Eric G. Wolfe
# Copyright 2023, Thomas Vincent
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#xq
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# SNMP Cookbook Default Attributes
# Sets default packages, services, and configurations for SNMP based on platform

# Default packages and service names, applicable to most platforms
default['snmp']['packages'] = %w(net-snmp net-snmp-utils)
default['snmp']['service'] = 'snmpd'

# Platform-specific adjustments
case node['platform_family']
when 'rhel', 'fedora', 'amazon', 'suse', 'opensuse', 'freebsd', 'mac_os_x', 'mac_os_x_server', 'aix'
  # No changes needed, defaults apply
when 'debian', 'ubuntu'
  default['snmp']['packages'] = %w(snmp snmpd)
when 'solaris2'
  default['snmp']['packages'] = %w(SUNWucsnmp)
  default['snmp']['service'] = 'svc:/network/snmp/dmi:default'
end

# Default SNMP community and security names
default['snmp']['community'] = 'public'
default['snmp']['sec_name'] = { notConfigUser: %w(default) }
default['snmp']['sec_name6'] = { notConfigUser: %w(default) }

# Default SNMP groups
default['snmp']['groups'] = {
  v1: { notConfigGroup: %w(notConfigUser) },
  v2c: { notConfigGroup: %w(notConfigUser) }
}

# Default SNMP trap configurations
default['snmp']['trap']['community'] = 'public'
default['snmp']['trap']['addresses'] = []
default['snmp']['trap']['port'] = 162

