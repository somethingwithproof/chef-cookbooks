#
# Cookbook:: tcp_wrappers
# Recipe:: default
#
# Copyright:: 2017-2025, Thomas Vincent
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

# Chef 18+ recommends declaring resources with a single block of code
# Install appropriate package using attribute
if platform_family?('debian', 'rhel', 'amazon', 'fedora')
  package node['authorization']['tcp_wrappers']['package'] do
    action :install
    compile_time false
  end
end

# Create wrappers.d directory with proper ownership and permissions
wrappers_dir = "#{node['authorization']['tcp_wrappers']['prefix']}/wrappers.d"
directory wrappers_dir do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
end

# Configure hosts.allow file if wrappers_d integration is enabled
if node['authorization']['tcp_wrappers']['include_wrappers_d']
  template '/etc/hosts.allow' do
    source 'hosts.allow.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      daemon: 'ALL',
      hosts_allow: '127.0.0.1',
      commands: []
    )
    action :create_if_missing
    sensitive true
    verify_contents false # Chef 18+ best practice
  end

  # Configure hosts.deny file if wrappers_d integration is enabled
  template '/etc/hosts.deny' do
    source 'hosts.deny.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      daemon: 'ALL',
      hosts_allow: 'ALL',
      commands: []
    )
    action :create_if_missing
    sensitive true
    verify_contents false # Chef 18+ best practice
  end
end