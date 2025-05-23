# frozen_string_literal: true

# Cookbook:: cookbook-template
# Resource:: example
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

# Modern Chef 19+ custom resource with unified mode
unified_mode true

provides :cookbook_template_example

# Resource properties with Chef 19+ syntax
property :service_name, String,
         name_property: true,
         description: 'Name of the service to manage'

property :port, Integer,
         default: 8080,
         description: 'Port number for the service',
         callbacks: {
           'must be a valid port number' => ->(p) { p.between?(1, 65_535) },
         }

property :enabled, [true, false],
         default: true,
         description: 'Whether the service should be enabled'

property :config_template, String,
         default: 'service.conf.erb',
         description: 'Template file name for configuration'

property :config_cookbook, String,
         default: 'cookbook-template',
         description: 'Cookbook containing the template'

property :user, String,
         default: lazy { node['cookbook_template']['service']['user'] },
         description: 'User to run the service as'

property :group, String,
         default: lazy { node['cookbook_template']['service']['group'] },
         description: 'Group to run the service as'

# Action methods
action :create do
  description 'Install and configure the example service'

  # Create service user and group
  group new_resource.group do
    system true
    action :create
  end

  user new_resource.user do
    group new_resource.group
    system true
    shell '/bin/false'
    home '/var/lib/example-service'
    action :create
  end

  # Install package
  package node['cookbook_template']['package']['name'] do
    action :install
  end

  # Create configuration directory
  directory ::File.dirname(config_file_path) do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end

  # Generate configuration file
  template config_file_path do
    source new_resource.config_template
    cookbook new_resource.config_cookbook
    owner node['cookbook_template']['config']['owner']
    group node['cookbook_template']['config']['group']
    mode node['cookbook_template']['config']['mode']
    variables(
      port: new_resource.port,
      enabled: new_resource.enabled,
      user: new_resource.user,
      group: new_resource.group,
      service_name: new_resource.service_name
    )
    notifies :restart, "service[#{service_name}]", :delayed
    action :create
  end

  # Create log directory
  directory ::File.dirname(node['cookbook_template']['logging']['file']) do
    owner new_resource.user
    group new_resource.group
    mode '0755'
    recursive true
    action :create
  end

  # Configure and start service
  service service_name do
    action new_resource.enabled ? %i(enable start) : %i(disable stop)
  end

  # Create systemd service file if on systemd platform
  if platform_uses_systemd?
    template "/etc/systemd/system/#{service_name}.service" do
      source 'systemd.service.erb'
      cookbook new_resource.config_cookbook
      owner 'root'
      group 'root'
      mode '0644'
      variables(
        service_name: new_resource.service_name,
        user: new_resource.user,
        group: new_resource.group,
        port: new_resource.port
      )
      notifies :run, 'execute[systemctl daemon-reload]', :immediately
      notifies :restart, "service[#{service_name}]", :delayed
      action :create
    end

    execute 'systemctl daemon-reload' do
      command '/bin/systemctl daemon-reload'
      action :nothing
    end
  end
end

action :remove do
  description 'Remove the example service'

  # Stop and disable service
  service service_name do
    action %i(stop disable)
  end

  # Remove configuration
  file config_file_path do
    action :delete
  end

  # Remove systemd service file
  file "/etc/systemd/system/#{service_name}.service" do
    action :delete
    notifies :run, 'execute[systemctl daemon-reload]', :immediately
    only_if { platform_uses_systemd? }
  end

  execute 'systemctl daemon-reload' do
    command '/bin/systemctl daemon-reload'
    action :nothing
    only_if { platform_uses_systemd? }
  end

  # Remove package
  package node['cookbook_template']['package']['name'] do
    action :remove
  end
end

action_class do
  # Helper methods for the resource

  def service_name
    @service_name ||= new_resource.service_name || node['cookbook_template']['service']['name']
  end

  def config_file_path
    @config_file_path ||= ::File.join(
      node['cookbook_template']['config']['path'],
      node['cookbook_template']['config']['file']
    )
  end

  def platform_uses_systemd?
    %w(ubuntu debian centos rhel rocky amazonlinux opensuse).include?(node['platform']) &&
      node['platform_version'].to_f >= case node['platform']
                                        when 'ubuntu'
                                          15.04
                                        when 'debian'
                                          8.0
                                        when 'centos', 'rhel', 'rocky'
                                          7.0
                                        when 'amazonlinux'
                                          2.0
                                        when 'opensuse'
                                          42.0
                                        else
                                          0.0
                                        end
  end
end