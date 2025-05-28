# Cookbook:: snmp
# Recipe:: snmptrapd
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

# Use the trapd resource to set up SNMP trap daemon
snmp_trapd 'default' do
  trap_community node['snmp']['trap']['community']
  trap_addresses node['snmp']['trap']['addresses']
  trap_port node['snmp']['trap']['port']
  trap_service node['snmp']['snmptrapd']['service']
end
