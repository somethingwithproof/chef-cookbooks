# frozen_string_literal: true

require 'spec_helper'

describe 'nginx::install' do
  before { stub_nginx_commands }

  context 'debian family' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04').converge(described_recipe)
    end

    it 'runs apt update for nginx' do
      expect(chef_run).to update_apt_update('nginx')
    end

    it 'runs the install-nginx execute block' do
      expect(chef_run).to run_execute('install-nginx')
    end

    it 'notifies the nginx service to reload' do
      expect(chef_run.execute('install-nginx')).to notify('service[nginx]').to(:reload).delayed
    end
  end

  context 'rhel family' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'rocky', version: '9').converge(described_recipe)
    end

    it 'creates the upstream yum repo' do
      expect(chef_run).to create_yum_repository('nginx').with(gpgcheck: true)
    end

    it 'installs nginx' do
      expect(chef_run).to install_package('nginx')
    end
  end

  context 'amazon linux' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'amazon', version: '2').converge(described_recipe)
    end

    it 'creates the upstream yum repo' do
      expect(chef_run).to create_yum_repository('nginx')
    end

    it 'installs nginx' do
      expect(chef_run).to install_package('nginx')
    end
  end

  context 'source install without a checksum' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['nginx']['install_method'] = 'source'
        node.normal['nginx']['source']['checksum'] = nil
      end.converge(described_recipe)
    end

    it 'raises' do
      expect { chef_run }.to raise_error(/checksum/)
    end
  end

  context 'source install with checksum' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['nginx']['install_method'] = 'source'
        node.normal['nginx']['source']['checksum'] = 'deadbeef' * 8
      end.converge(described_recipe)
    end

    it 'installs build_essential' do
      expect(chef_run).to install_build_essential('install_build_tools')
    end

    it 'creates the nginx system user' do
      expect(chef_run).to create_user('www-data').with(system: true)
    end
  end
end
