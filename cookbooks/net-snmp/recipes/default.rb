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

# Reject insecure defaults before doing anything else.
NetSnmp::Security.validate_community_strings!(node['net_snmp']['community_strings'])
NetSnmp::Security.validate_community_strings!(
  [{ 'community' => node['net_snmp']['trapd']['community'] }]
) if node['net_snmp']['trapd']['community']

# Install Net-SNMP based on platform
case node['platform_family']
when 'rhel', 'fedora', 'amazon'
  package %w(net-snmp net-snmp-utils) do
    action :install
  end
when 'debian'
  package %w(snmp snmpd snmp-mibs-downloader) do
    action :install
  end
end

# Configure SNMPv3 if users are defined
if node['net_snmp']['v3_users'] && !node['net_snmp']['v3_users'].empty?
  # Create snmpd.conf.d directory for modular configuration
  directory node['net_snmp']['config_include_dir'] do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
  end

  # Create snmpd.conf with SNMPv3 configuration
  template node['net_snmp']['config_file'] do
    source 'snmpd.conf.erb'
    owner 'root'
    group 'root'
    mode '0600'
    sensitive true
    variables(
      sys_location: node['net_snmp']['sys_location'],
      sys_contact: node['net_snmp']['sys_contact'],
      sys_name: node['net_snmp']['sys_name'],
      listen_address: node['net_snmp']['listen_address'],
      community_strings: node['net_snmp']['community_strings'],
      v3_users: node['net_snmp']['v3_users'],
      views: node['net_snmp']['views'],
      groups: node['net_snmp']['groups'],
      access_rules: node['net_snmp']['access_rules'],
      disk_monitoring: node['net_snmp']['disk_monitoring'],
      load_thresholds: node['net_snmp']['load_thresholds'],
      extend_scripts: node['net_snmp']['extend_scripts'],
      pass_scripts: node['net_snmp']['pass_scripts'],
      disable_snmpv1: node['net_snmp']['disable_snmpv1'],
      disable_snmpv2c: node['net_snmp']['disable_snmpv2c']
    )
    notifies :restart, 'service[snmpd]', :delayed
  end

  # Create SNMPv3 users
  node['net_snmp']['v3_users'].each do |user|
    username = user['username'] || user[:username]
    auth_password = user['auth_password'] || user[:auth_password]
    auth_protocol = user['auth_protocol'] || user[:auth_protocol] || 'SHA'
    priv_password = user['priv_password'] || user[:priv_password]
    priv_protocol = user['priv_protocol'] || user[:priv_protocol] || 'AES'

    # Stop snmpd before creating users (required for net-snmp-create-v3-user)
    execute "create_snmpv3_user_#{username}" do
      command [
        'bash',
        '-c',
        "service snmpd stop || true; net-snmp-create-v3-user -ro -A \"$AUTH_PASS\" -a #{auth_protocol} -X \"$PRIV_PASS\" -x #{priv_protocol} #{username}; service snmpd start",
      ]
      environment(
        'AUTH_PASS' => auth_password,
        'PRIV_PASS' => priv_password
      )
      sensitive true
      not_if "grep -q 'usmUser.*#{username}' /var/lib/snmp/snmpd.conf 2>/dev/null"
    end
  end
end

# Start and enable SNMP service
service node['net_snmp']['service_name'] do
  action %i(enable start)
end
