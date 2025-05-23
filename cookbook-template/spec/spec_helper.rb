# frozen_string_literal: true

require 'chefspec'
require 'simplecov'

# Coverage reporting
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/test/'
  add_filter '/vendor/'
  add_group 'Resources', 'resources'
  add_group 'Recipes', 'recipes'
  add_group 'Libraries', 'libraries'
  add_group 'Attributes', 'attributes'

  minimum_coverage 80
  refuse_coverage_drop
end

# ChefSpec configuration
RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
  config.file_cache_path = '/tmp/chef-cache'
  config.cookbook_path = [File.expand_path('../../', __FILE__)]
end

# Platform configurations for testing
PLATFORMS = {
  'ubuntu-20.04' => {
    platform: 'ubuntu',
    version: '20.04',
    platform_family: 'debian'
  },
  'ubuntu-22.04' => {
    platform: 'ubuntu',
    version: '22.04',
    platform_family: 'debian'
  },
  'debian-11' => {
    platform: 'debian',
    version: '11',
    platform_family: 'debian'
  },
  'centos-7' => {
    platform: 'centos',
    version: '7',
    platform_family: 'rhel'
  },
  'rockylinux-8' => {
    platform: 'rocky',
    version: '8',
    platform_family: 'rhel'
  },
  'amazonlinux-2' => {
    platform: 'amazon',
    version: '2',
    platform_family: 'amazon'
  }
}.freeze

# Helper methods for specs
def stub_command_and_return(command, value)
  stub_command(command).and_return(value)
end

def expect_package_install(package_name)
  expect(chef_run).to install_package(package_name)
end

def expect_service_enable_and_start(service_name)
  expect(chef_run).to enable_service(service_name)
  expect(chef_run).to start_service(service_name)
end

def expect_template_create(path)
  expect(chef_run).to create_template(path)
end

# Shared examples for platform testing
RSpec.shared_examples 'cookbook template platform' do |platform_name|
  let(:platform_config) { PLATFORMS[platform_name] }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: platform_config[:platform],
      version: platform_config[:version],
      step_into: ['cookbook_template_example']
    ) do |node|
      node.automatic['platform_family'] = platform_config[:platform_family]
    end.converge(described_recipe)
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end
