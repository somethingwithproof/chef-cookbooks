# Cookbook:: snmp
# Recipe:: default
#
# Copyright:: 2010-2023, Eric G. Wolfe, Thomas Vincent
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
# Installs and configures SNMP service using the new custom resource

snmp_install 'default' do
  community node['snmp']['community']
  groups node['snmp']['groups']
  sec_name node['snmp']['sec_name']
  sec_name6 node['snmp']['sec_name6']
  trap_community node['snmp']['trap']['community']
  trap_addresses node['snmp']['trap']['addresses']
  trap_port node['snmp']['trap']['port']
end
