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
                   'net-snmp'
                 when 'debian'
                   'snmpd'
                 end

package daemon_package do
  action :install
end

# Install net-snmp-utils for SNMPv3 user creation on RHEL-based systems
if platform_family?('rhel', 'fedora', 'amazon')
  package 'net-snmp-utils' do
    action :install
  end
end

# Configure SNMPv3 if enabled
if node['net-snmp']['snmpv3']['enabled']
  # Determine config directory based on platform
  snmp_conf_dir = '/etc/snmp'

  # Create snmpd.conf with SNMPv3 configuration
  template "#{snmp_conf_dir}/snmpd.conf" do
    source 'snmpd.conf.erb'
    owner 'root'
    group 'root'
    mode '0600'
    sensitive true
    variables(
      snmpv3_users: node['net-snmp']['snmpv3']['users']
    )
    notifies :restart, 'service[snmpd]', :delayed
  end

  # Create SNMPv3 users
  node['net-snmp']['snmpv3']['users'].each do |user|
    # Stop snmpd before creating users (required for net-snmp-create-v3-user)
    execute "create_snmpv3_user_#{user['username']}" do
      command <<-EOH
        service snmpd stop || true
        net-snmp-create-v3-user -ro \
          -A '#{user['auth_password']}' \
          -a #{user['auth_protocol']} \
          -X '#{user['priv_password']}' \
          -x #{user['priv_protocol']} \
          #{user['username']}
        service snmpd start
      EOH
      sensitive true
      not_if "grep -q 'usmUser.*#{user['username']}' /var/lib/snmp/snmpd.conf 2>/dev/null"
    end
  end
end

# Service name
service_name = 'snmpd'

# Start and enable SNMP service
service service_name do
  action [:enable, :start]
end
