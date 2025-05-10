#
# Cookbook:: test
# Recipe:: create
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

# Set attribute for testing
node.default['authorization']['tcp_wrappers']['include_wrappers_d'] = true

# Include the default recipe to do the base setup
include_recipe 'tcp_wrappers::default'

# Create multiple tcp_wrappers entries
tcp_wrappers 'sshd' do
  daemon 'sshd' 
  hosts ['192.168.1.0/24']
  commands ['spawn /bin/echo `/bin/date` access granted>>/var/log/sshd.log']
  action :install
end

tcp_wrappers 'ftpd' do
  daemon 'ftpd'
  hosts ['10.0.0.0/8']
  commands ['spawn /bin/echo `/bin/date` access granted>>/var/log/ftpd.log']
  action :install
end

tcp_wrappers 'all_services' do
  daemon 'ALL'
  hosts ['127.0.0.1']
  commands ['ALLOW']
  action :install
end