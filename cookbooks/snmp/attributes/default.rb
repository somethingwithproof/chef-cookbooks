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

# Default SNMP community and security names
default['snmp']['community'] = 'public'
default['snmp']['sec_name'] = { notConfigUser: %w(default) }
default['snmp']['sec_name6'] = { notConfigUser: %w(default) }

# Default SNMP groups
default['snmp']['groups'] = {
  v1: { notConfigGroup: %w(notConfigUser) },
  v2c: { notConfigGroup: %w(notConfigUser) },
}

# Default SNMP trap configurations
default['snmp']['trap']['community'] = 'public'
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
default['snmp']['trapcommunity'] = 'public'
default['snmp']['trapsinks'] = []

# Disman event configuration
default['snmp']['disman_events'] = {
  'enable' => false,
  'user' => 'disman_events',
  'password' => 'dismanEventsMIB',
  'linkUpDownNotifications' => 'yes',
  'defaultMonitors' => 'yes',
  'monitors' => [],
}
