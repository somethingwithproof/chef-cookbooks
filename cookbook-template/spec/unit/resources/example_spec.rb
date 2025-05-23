# frozen_string_literal: true

require 'spec_helper'

describe 'cookbook_template_example' do
  let(:described_recipe) { 'cookbook-template::default' }

  # Test resource on multiple platforms
  PLATFORMS.each do |platform_name, _platform_config|
    context "on #{platform_name}" do
      include_examples 'cookbook template platform', platform_name

      let(:resource) { chef_run.cookbook_template_example('default_service') }

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
          expect_package_install('example-service')
        end

        it 'creates configuration directory' do
          expect(chef_run).to create_directory('/etc/example-service').with(
            owner: 'root',
            group: 'root',
            mode: '0755'
          )
        end

        it 'creates configuration file' do
          expect_template_create('/etc/example-service/service.conf')
          template = chef_run.template('/etc/example-service/service.conf')
          expect(template.source).to eq('service.conf.erb')
          expect(template.cookbook).to eq('cookbook-template')
        end

        it 'creates log directory' do
          expect(chef_run).to create_directory('/var/log').with(
            owner: 'app',
            group: 'app',
            mode: '0755'
          )
        end

        it 'enables and starts service when enabled' do
          expect_service_enable_and_start('example-service')
        end

        context 'on systemd platforms' do
          before do
            allow_any_instance_of(Chef::Resource).to receive(:platform_uses_systemd?).and_return(true)
          end

          it 'creates systemd service file' do
            expect_template_create('/etc/systemd/system/example-service.service')
            template = chef_run.template('/etc/systemd/system/example-service.service')
            expect(template.source).to eq('systemd.service.erb')
          end

          it 'runs systemctl daemon-reload' do
            expect(chef_run).to_not run_execute('systemctl daemon-reload')
            template = chef_run.template('/etc/systemd/system/example-service.service')
            expect(template).to notify('execute[systemctl daemon-reload]').to(:run).immediately
          end
        end
      end

      describe 'action :remove' do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(
            platform: PLATFORMS[platform_name][:platform],
            version: PLATFORMS[platform_name][:version],
            step_into: ['cookbook_template_example']
          ) do |node|
            node.automatic['platform_family'] = PLATFORMS[platform_name][:platform_family]
          end.converge('cookbook-template::default')
        end

        before do
          chef_run.cookbook_template_example('default_service').run_action(:remove)
        end

        it 'stops and disables service' do
          expect(chef_run).to stop_service('example-service')
          expect(chef_run).to disable_service('example-service')
        end

        it 'removes configuration file' do
          expect(chef_run).to delete_file('/etc/example-service/service.conf')
        end

        it 'removes package' do
          expect(chef_run).to remove_package('example-service')
        end

        context 'on systemd platforms' do
          before do
            allow_any_instance_of(Chef::Resource).to receive(:platform_uses_systemd?).and_return(true)
          end

          it 'removes systemd service file' do
            expect(chef_run).to delete_file('/etc/systemd/system/example-service.service')
          end
        end
      end

      describe 'property validation' do
        it 'validates port range' do
          expect do
            ChefSpec::SoloRunner.new(
              platform: PLATFORMS[platform_name][:platform],
              version: PLATFORMS[platform_name][:version],
              step_into: ['cookbook_template_example']
            ).converge do
              cookbook_template_example 'invalid_port' do
                port 70000
                action :create
              end
            end
          end.to raise_error(Chef::Exceptions::ValidationFailed)
        end

        it 'accepts valid port' do
          expect do
            ChefSpec::SoloRunner.new(
              platform: PLATFORMS[platform_name][:platform],
              version: PLATFORMS[platform_name][:version],
              step_into: ['cookbook_template_example']
            ).converge do
              cookbook_template_example 'valid_port' do
                port 8080
                action :create
              end
            end
          end.to_not raise_error
        end
      end
    end
  end
end
