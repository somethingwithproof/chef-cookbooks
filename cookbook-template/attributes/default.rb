# frozen_string_literal: true

# Cookbook:: cookbook-template
# Attributes:: default
#
# Copyright:: 2024, Thomas Vincent
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Service configuration
default['cookbook_template']['service']['port'] = 8080
default['cookbook_template']['service']['enabled'] = true
default['cookbook_template']['service']['user'] = 'app'
default['cookbook_template']['service']['group'] = 'app'

# Package configuration - platform specific defaults
case node['platform_family']
when 'debian'
  default['cookbook_template']['package']['name'] = 'example-service'
  default['cookbook_template']['service']['name'] = 'example-service'
when 'rhel', 'fedora', 'amazon'
  default['cookbook_template']['package']['name'] = 'example-service'
  default['cookbook_template']['service']['name'] = 'example-service'
when 'suse'
  default['cookbook_template']['package']['name'] = 'example-service'
  default['cookbook_template']['service']['name'] = 'example-service'
else
  default['cookbook_template']['package']['name'] = 'example-service'
  default['cookbook_template']['service']['name'] = 'example-service'
end

# Configuration file settings
default['cookbook_template']['config']['template'] = 'service.conf.erb'
default['cookbook_template']['config']['cookbook'] = 'cookbook-template'
default['cookbook_template']['config']['path'] = '/etc/example-service'
default['cookbook_template']['config']['file'] = 'service.conf'
default['cookbook_template']['config']['mode'] = '0644'
default['cookbook_template']['config']['owner'] = 'root'
default['cookbook_template']['config']['group'] = 'root'

# Logging configuration
default['cookbook_template']['logging']['level'] = 'info'
default['cookbook_template']['logging']['file'] = '/var/log/example-service.log'
default['cookbook_template']['logging']['max_size'] = '100MB'
default['cookbook_template']['logging']['rotate_count'] = 10
