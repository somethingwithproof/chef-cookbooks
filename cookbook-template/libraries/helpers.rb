# frozen_string_literal: true

# Cookbook:: cookbook-template
# Library:: helpers
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

# Chef 19+ helper methods for cookbook-template
module CookbookTemplate
  module Helpers
    # Platform detection helpers
    def systemd_platform?
      platform_family?('rhel', 'debian', 'suse') &&
        (platform?('ubuntu') && node['platform_version'].to_f >= 15.04) ||
        (platform?('debian') && node['platform_version'].to_i >= 8) ||
        (platform_family?('rhel') && node['platform_version'].to_i >= 7) ||
        (platform?('opensuse') && node['platform_version'].to_f >= 42.0)
    end

    # Service management helpers
    def service_manager
      return 'systemd' if systemd_platform?
      return 'upstart' if platform?('ubuntu') && node['platform_version'].to_f < 15.04
      return 'sysvinit'
    end

    # Configuration helpers
    def config_format(value)
      case value
      when Hash
        value.map { |k, v| "#{k}=#{v}" }.join("\n")
      when Array
        value.join(',')
      else
        value.to_s
      end
    end

    # Version comparison helpers
    def version_compare(version1, operator, version2)
      Gem::Version.new(version1.to_s).send(operator, Gem::Version.new(version2.to_s))
    end

    # Network helpers
    def valid_port?(port)
      port.is_a?(Integer) && port.between?(1, 65_535)
    end

    def port_open?(host, port, timeout = 5)
      require 'socket'
      require 'timeout'

      Timeout.timeout(timeout) do
        TCPSocket.new(host, port).close
        true
      end
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
      false
    end

    # File system helpers
    def safe_file_path(path)
      ::File.expand_path(path).gsub(/\.\./, '')
    end

    def directory_exists?(path)
      ::File.directory?(path)
    end

    def file_exists?(path)
      ::File.exist?(path)
    end

    # Template rendering helpers
    def render_config(template_vars = {})
      default_vars = {
        cookbook_name: cookbook_name,
        node_name: node.name,
        timestamp: Time.now.strftime('%Y-%m-%d %H:%M:%S %Z')
      }
      default_vars.merge(template_vars)
    end

    # Resource notification helpers
    def notify_restart_service(service_name, timing = :delayed)
      notifies :restart, "service[#{service_name}]", timing
    end

    def notify_reload_service(service_name, timing = :delayed)
      notifies :reload, "service[#{service_name}]", timing
    end
  end
end

# Include helpers in Chef::Recipe and Chef::Resource
Chef::Recipe.include(CookbookTemplate::Helpers)
Chef::Resource.include(CookbookTemplate::Helpers)
