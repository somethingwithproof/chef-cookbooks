# frozen_string_literal: true

require 'spec_helper'

describe 'cookbook-template::default' do
  let(:described_recipe) { 'cookbook-template::default' }

  # Test on multiple platforms
  PLATFORMS.each do |platform_name, _platform_config|
    context "on #{platform_name}" do
      include_examples 'cookbook template platform', platform_name

      it 'creates cookbook_template_example resource' do
        expect(chef_run).to create_cookbook_template_example('default_service')
      end

      it 'configures default service port' do
        resource = chef_run.cookbook_template_example('default_service')
        expect(resource.port).to eq(8080)
      end

      it 'enables service by default' do
        resource = chef_run.cookbook_template_example('default_service')
        expect(resource.enabled).to be true
      end

      it 'uses default config template' do
        resource = chef_run.cookbook_template_example('default_service')
        expect(resource.config_template).to eq('service.conf.erb')
      end
    end
  end

  context 'with custom attributes' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '20.04',
        step_into: ['cookbook_template_example']
      ) do |node|
        node.override['cookbook_template']['service']['port'] = 9000
        node.override['cookbook_template']['service']['enabled'] = false
        node.override['cookbook_template']['config']['template'] = 'custom.conf.erb'
      end.converge(described_recipe)
    end

    it 'uses custom port from attributes' do
      resource = chef_run.cookbook_template_example('default_service')
      expect(resource.port).to eq(9000)
    end

    it 'respects enabled setting from attributes' do
      resource = chef_run.cookbook_template_example('default_service')
      expect(resource.enabled).to be false
    end

    it 'uses custom template from attributes' do
      resource = chef_run.cookbook_template_example('default_service')
      expect(resource.config_template).to eq('custom.conf.erb')
    end
  end
end