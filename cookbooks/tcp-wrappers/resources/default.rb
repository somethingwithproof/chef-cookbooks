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

description 'Resource to configure TCP Wrappers for services'
introduced '0.1.0'
examples <<~DOC
  # Basic usage
  tcp_wrappers 'sshd' do
    daemon 'sshd'
    hosts ['192.168.1.0/24', '10.0.0.0/8']
    commands ['spawn /bin/echo `/bin/date` access granted>>/var/log/sshd.log']
    action :install
  end

  # With custom template
  tcp_wrappers 'ftpd' do
    daemon 'ftpd'
    hosts ['localhost']
    template 'my_custom_template.erb'
    variables({
      custom_var: 'value'
    })
    action :install
  end
DOC

property :daemon, String,
         description: 'The daemon to configure in TCP Wrappers',
         required: true
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
      verify_contents false # Chef 18+ best practice for template verification
    end

    Chef::Log.debug("Custom template used for #{new_resource.name}")
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
      verify_contents false # Chef 18+ best practice for template verification
    end
  end
end

# Documentation for the remove action
action_class.class_eval do
  def action_remove
    describe_recipe 'Remove specified TCP wrappers configuration'
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
    # Chef 18+ idiomatic - use Ruby string methods
    new_resource.name.tr('.~', '__')
  end
end
