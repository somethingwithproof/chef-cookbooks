#
# Cookbook:: tcp_wrappers
# Attribute:: default
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
#

# Basic configuration defaults - structured for Chef 18+
default['authorization']['tcp_wrappers'] = {
  'hosts' => [],
  'daemons' => [],
  'options' => [],
  'hosts_allow_defaults' => [],
  'prefix' => '/etc',
  'include_wrappers_d' => true,
}

# Platform-specific settings
# All supported platforms (Ubuntu 22.04+, Debian 12+, RHEL 9+) use 'tcpd'
default['authorization']['tcp_wrappers']['package'] = case node['platform_family']
                                                      when 'debian'
                                                        'tcpd'
                                                      when 'rhel', 'amazon', 'fedora'
                                                        'tcp_wrappers'
                                                      else
                                                        'tcp_wrappers'
                                                      end
