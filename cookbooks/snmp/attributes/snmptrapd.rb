# Cookbook:: snmp
# Attributes:: snmptrapd
#
# Copyright:: 2013-2023, Eric G. Wolfe, Thomas Vincent
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

# SNMP Trap daemon configuration
default['snmp']['snmptrapd']['trapd_run'] = 'no'
default['snmp']['snmptrapd']['service_name'] = platform_family?('rhel') ? 'snmptrapd' : 'snmpd'
default['snmp']['snmptrapd']['traphandle'] = 'default /usr/sbin/snmptthandler'
default['snmp']['snmptrapd']['disableAuthorization'] = 'yes'
default['snmp']['snmptrapd']['donotlogtraps'] = 'no'

# Debian-specific SNMP daemon config
default['snmp']['snmpd']['mibdirs'] = '/usr/share/snmp/mibs'
default['snmp']['snmpd']['snmpd_run'] = 'yes'
default['snmp']['snmpd']['snmpd_opts'] = '-Lsd -Lf /dev/null -u snmp -g snmp -I -smux -p /var/run/snmpd.pid'
default['snmp']['snmpd']['trapd_opts'] = '-Lsd -p /var/run/snmptrapd.pid'
default['snmp']['snmpd']['snmpd_compat'] = 'yes'
