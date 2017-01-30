#
# Author:: Thomas Vincent <thomasvincent@gmail.com>
# Cookbook:: tcp_wrappers
# Provider:: default
#
# Copyright:: 2017, Thomas Vincent
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

use_inline_resources

# This LWRP supports whyrun mode
def whyrun_supported?
  true
end

# Ensure that the inputs are valid (we cannot just use the resource for this)
def check_inputs(daemon, client, option_template, _foreign_vars)
  # if group, user, and template are nil, throw an exception
  if daemon.nil? && client.nil? && option.nil?
    raise 'You must provide a daemon, client, and option!'
  elsif !user.nil? && !group.nil? && !template.nil?
    raise 'You cannot specify user, group, and template!'
  end
end

# Validate the given resource (template) by writing it out to a file and then
# ensuring that file's contents pass `visudo -c`
def validate_fragment!(resource)
  file = Tempfile.new('hosts_allow')

  begin
    file.write(capture(resource))
    file.rewind

    cmd = Mixlib::ShellOut.new("visudo -cf #{file.path}").run_command
    unless cmd.exitstatus.zero?
      Chef::Log.error("Fragment validation failed: \n\n")
      Chef::Log.error(file.read)
      Chef::Application.fatal!("Template #{file.path} failed fragment validation!")
    end
  ensure
    file.close
    file.unlink
  end
end

# Render a single hosts_allow template. This method has two modes:
#   1. using the :template option - the user can specify a template
#      that exists in the local cookbook for writing out the attributes
#   2. using the built-in template (recommended) - simply pass the
#      desired variables to the method and the correct template will be
#      written out for the user
def render_wrapper
  if new_resource.template
    Chef::Log.debug('Template attribute provided, all other attributes ignored.')

    resource = template "#{node['authorization']['tcp_wrappers']['prefix']}#{tcp_wrappers_filename}" do
      source new_resource.template
      owner 'root'
      group node['root_group']
      mode '0440'
      variables new_resource.variables
      action :nothing
    end
  else
    hosts_allow = new_resource.user || ("%#{new_resource.group}".squeeze('%') if new_resource.group)

    resource = template "#{node['authorization']['tcp_wrappers']['prefix']}/wrappers.d/#{tcp_wrappers_filename}" do
      source 'hosts_allow.erb'
      cookbook 'tcp_wrappers'
      owner 'root'
      group node['root_group']
      mode '0440'
      variables hosts_allow:             hosts_allow,
                daemon_list:        new_resource.daemon_list,
                client_list:        new_resource.client_list,
                shell_command:      new_resource.shell_command
      action :nothing
    end
  end

  resource.run_action(:create)

  # Return whether the resource was updated so we can notify in the action
  resource.updated_by_last_action?
end

# Default action - install a single hosts_allow
action :install do
  target = "#{node['authorization']['tcp_wrappers']['prefix']}"

  unless ::File.exist?(target)
    wrappers_dir = directory target
    wrappers_dir.run_action(:create)
  end

  Chef::Log.warn("#{tcp_wrappers_filename} will be rendered, but will not take effect because node['authorization']['tcp_wrappers']['include_wrappers_d'] is set to false!") unless node['authorization']['tcp_wrappers']['include_wrappers_d']
  new_resource.updated_by_last_action(true) if render_wrapper
end

# Removes a user from the wrappers group
action :remove do
  resource = file "#{node['authorization']['tcp_wrappers']['prefix']}/wrappers.d/#{tcp_wrappers_filename}" do
    action :nothing
  end
  resource.run_action(:delete)
  new_resource.updated_by_last_action(true) if resource.updated_by_last_action?
end

private

# acording to the tcp_wrappers man pages tcp_wrappers will ignore files in an include dir that have a `.` or `~`
# We convert either to `__`
def tcp_wrappers_filename
  new_resource.name.gsub(/[\.~]/, '__')
end

# Capture a template to a string
def capture(template)
  context = {}
  context.merge!(template.variables)
  context[:node] = node

  eruby = Erubis::Eruby.new(::File.read(template_location(template)))
  eruby.evaluate(context)
end

# Find the template
def template_location(template)
  if template.local
    template.source
  else
    context = template.instance_variable_get('@run_context')
    cookbook = context.cookbook_collection[template.cookbook || template.cookbook_name]
    cookbook.preferred_filename_on_disk_location(node, :templates, template.source)
  end
end
