# Cookbook:: snmp
# Attributes:: default
#
# Copyright:: 2010-2023, Eric G. Wolfe, Thomas Vincent
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

# SNMP Cookbook Default Attributes

# Network binding configuration
# SECURITY: Bind to localhost only by default - set to 'udp:161' to bind to all interfaces
default['snmp']['agent_address'] = 'udp:127.0.0.1:161'

# Default SNMP community and security names
# SECURITY: Default community string is empty - must be explicitly configured
default['snmp']['community'] = ''
# SECURITY: com2sec source defaults to 'localhost'. Using 'default' (or '0.0.0.0/0')
# is the all-hosts wildcard and is forbidden by this cookbook -- override per node
# with the explicit network you intend to monitor from (e.g. '10.0.0.0/8').
default['snmp']['sec_name'] = { notConfigUser: %w(localhost) }
default['snmp']['sec_name6'] = { notConfigUser: %w(::1) }

# Default SNMP groups
# SECURITY: SNMPv2c only by default - v1 is deprecated and insecure
default['snmp']['groups'] = {
  v2c: { notConfigGroup: %w(notConfigUser) },
}

# Default SNMP trap configurations
# SECURITY: Default community string is empty - must be explicitly configured
default['snmp']['trap']['community'] = ''
default['snmp']['trap']['addresses'] = []
default['snmp']['trap']['port'] = 162

# SNMP Extend configuration
default['snmp']['extend']['scripts'] = '/usr/share/snmp'
default['snmp']['extend_scripts'] = {}

# System location and contact info
default['snmp']['syslocationPhysical'] = 'Server Room'
default['snmp']['syslocationVirtual'] = 'Virtual Server'
default['snmp']['syscontact'] = 'Root <root@localhost>'

# Process monitoring
default['snmp']['process_monitoring'] = {
  'proc' => [],
  'procfix' => [],
}

# Disk monitoring
default['snmp']['include_all_disks'] = false
default['snmp']['all_disk_min'] = 100 # minimum kB free space
default['snmp']['disks'] = []

# Load monitoring
default['snmp']['load_average'] = {}

# Default trapsink configuration
default['snmp']['full_systemview'] = false
# SECURITY: Default community string is empty - must be explicitly configured
default['snmp']['trapcommunity'] = ''
default['snmp']['trapsinks'] = []

# Disman event configuration
default['snmp']['disman_events'] = {
  'enable' => false,
  'user' => 'disman_events',
  # SECURITY: No default password - must be explicitly configured
  'password' => '',
  'auth_protocol' => 'SHA-256',
  'linkUpDownNotifications' => 'yes',
  'defaultMonitors' => 'yes',
  'monitors' => [],
}
