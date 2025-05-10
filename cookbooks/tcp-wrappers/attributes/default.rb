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

# Basic configuration defaults
default['authorization']['tcp_wrappers']['hosts'] = []
default['authorization']['tcp_wrappers']['daemons'] = []
default['authorization']['tcp_wrappers']['options'] = []
default['authorization']['tcp_wrappers']['hosts_allow_defaults'] = []

# Installation and setup
default['authorization']['tcp_wrappers']['prefix'] = '/etc'
default['authorization']['tcp_wrappers']['include_wrappers_d'] = true

# Platform-specific settings
default['authorization']['tcp_wrappers']['package'] = value_for_platform(
  ['ubuntu'] => {
    '>= 22.04' => 'tcpd',
    'default' => 'tcp_wrappers'
  },
  'default' => 'tcp_wrappers'
)
