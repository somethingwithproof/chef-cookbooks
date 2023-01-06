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

# Set the SNMP packages to install based on the platform family
case node['platform_family']
when 'rhel'
  default['snmp']['packages'] = %w(net-snmp net-snmp-utils)
when 'debian'
  default['snmp']['packages'] = %w(snmp snmpd)
when 'suse'
  default['snmp']['packages'] = %w(net-snmp)
else
  default['snmp']['packages'] = %w(net-snmp net-snmp-utils)
end

# Set the SNMP service name to the same value on all supported platforms
default['snmp']['service'] = 'snmpd'

# Default SNMP community and security names
default['snmp']['community'] = 'public'
default['snmp']['sec_name'] = { 'notConfigUser' => %w(default) }
default['snmp']['sec_name6'] = { 'notConfigUser' => %w(default) }

# Default SNMP groups for v1 and v2c
default['snmp']['groups']['v1'] = { 'notConfigGroup' => %w(notConfigUser) }
default['snmp']['groups']['v2c'] = { 'notConfigGroup' => %w(notConfigUser) }

# Default
