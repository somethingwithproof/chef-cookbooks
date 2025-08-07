#
# Cookbook:: net-snmp
# Recipe:: default
#
# Copyright:: 2025, Thomas Vincent
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

# Install Net-SNMP package
package_name = case node['platform_family']
               when 'rhel', 'fedora', 'amazon'
                 'net-snmp'
               when 'debian'
                 'snmp'
               end

package package_name do
  action :install
end

# Install SNMP daemon
daemon_package = case node['platform_family']
                 when 'rhel', 'fedora', 'amazon'
                   'net-snmp-agent-libs'
                 when 'debian'
                   'snmpd'
                 end

package daemon_package do
  action :install
end
# Start and enable SNMP service
service 'snmpd' do
  action [:enable, :start]
end
