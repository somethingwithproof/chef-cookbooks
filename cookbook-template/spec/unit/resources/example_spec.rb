# frozen_string_literal: true

require 'spec_helper'

describe 'cookbook_template_example' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '22.04',
      step_into: ['cookbook_template_example']
    ).converge('cookbook-template::default')
  end

  describe 'action :create' do
    it 'creates service group' do
      expect(chef_run).to create_group('app')
    end

    it 'creates service user' do
      expect(chef_run).to create_user('app').with(
        group: 'app',
        system: true,
        shell: '/bin/false'
      )
    end

    it 'installs package' do
      expect(chef_run).to install_package('example-service')
    end

    it 'creates configuration directory' do
      expect(chef_run).to create_directory('/etc/example-service').with(
        owner: 'root',
        group: 'root',
        mode: '0755'
      )
    end

    it 'creates configuration file' do
      expect(chef_run).to create_template('/etc/example-service/service.conf').with(
        source: 'service.conf.erb',
        cookbook: 'cookbook-template'
      )
    end

    it 'creates log directory' do
      expect(chef_run).to create_directory('/var/log').with(
        owner: 'app',
        group: 'app',
        mode: '0755'
      )
    end

    it 'enables and starts service' do
      expect(chef_run).to enable_service('default_service')
      expect(chef_run).to start_service('default_service')
    end
  end

  describe 'property validation' do
    it 'validates port range' do
      expect do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '22.04',
          step_into: ['cookbook_template_example']
        ) do |node|
          node.normal['cookbook_template']['service']['port'] = 70_000
        end.converge('cookbook-template::default')
      end.to raise_error(Chef::Exceptions::ValidationFailed)
    end

    it 'accepts valid port' do
      expect do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '22.04',
          step_into: ['cookbook_template_example']
        ).converge('cookbook-template::default')
      end.to_not raise_error
    end
  end
end
