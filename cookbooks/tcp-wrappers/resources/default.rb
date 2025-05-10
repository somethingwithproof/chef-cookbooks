#
# Author:: Thomas Vincent (<thomasvincent@gmail.com>)
# Cookbook:: tcp_wrappers
# Resource:: default
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

unified_mode true

provides :tcp_wrappers

property :daemon, String,
         description: 'The daemon to configure in TCP Wrappers'
property :hosts, Array,
         default: [],
         description: 'The hosts to allow or deny'
property :commands, Array,
         default: [],
         description: 'Commands to execute when a rule matches'
property :template, String,
         description: 'Optional template to use instead of the default'
property :variables, Hash,
         default: {},
         coerce: proc { |v| v.is_a?(Hash) ? v : {} },
         description: 'Template variables when using a custom template'

action :install do
  target = node['authorization']['tcp_wrappers']['prefix'].to_s

  # Create target directory if it doesn't exist
  directory target do
    action :create
  end

  # Create wrappers.d directory if it doesn't exist
  wrappers_dir = "#{target}/wrappers.d"
  directory wrappers_dir do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
  end

  log 'TCP Wrappers Warning' do
    message "#{tcp_wrappers_filename} will be rendered, but will not take effect because node['authorization']['tcp_wrappers']['include_wrappers_d'] is set to false!"
    level :warn
    not_if { node['authorization']['tcp_wrappers']['include_wrappers_d'] }
  end

  if new_resource.template
    template_path = "#{target}#{tcp_wrappers_filename}"
    template template_path do
      source new_resource.template
      owner 'root'
      group 'root'
      mode '0440'
      variables new_resource.variables
      sensitive true
    end

    log "Custom template used for #{new_resource.name}" do
      level :debug
    end
  else
    # Join hosts with a space
    hosts_allow = new_resource.hosts.join(' ')
    template_path = "#{wrappers_dir}/#{tcp_wrappers_filename}"

    template template_path do
      source 'hosts_allow.erb'
      cookbook 'tcp_wrappers'
      owner 'root'
      group 'root'
      mode '0440'
      variables(
        hosts_allow: hosts_allow,
        daemon: new_resource.daemon,
        commands: new_resource.commands
      )
      sensitive true
    end
  end
end

action :remove do
  target = node['authorization']['tcp_wrappers']['prefix'].to_s
  file_path = "#{target}/wrappers.d/#{tcp_wrappers_filename}"

  file file_path do
    action :delete
  end
end

action_class do
  # According to the tcp_wrappers man pages tcp_wrappers will ignore files in an include dir that have a `.` or `~`
  # We convert either to `__`
  def tcp_wrappers_filename
    # Chef 16 idiomatic - use Ruby string methods
    new_resource.name.tr('.~', '__')
  end
end
