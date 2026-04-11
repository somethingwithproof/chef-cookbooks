# frozen_string_literal: true

require 'spec_helper'

describe 'nginx::telemetry' do
  before { stub_nginx_commands }

  context 'with telemetry disabled (default)' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04').converge(described_recipe)
    end

    it 'does not fetch the exporter tarball' do
      expect(chef_run).not_to create_remote_file("#{Chef::Config[:file_cache_path]}/nginx-prometheus-exporter.tar.gz")
    end
  end

  context 'with telemetry enabled' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['nginx']['telemetry']['enabled'] = true
        node.normal['nginx']['telemetry']['prometheus']['exporter_checksum'] = 'deadbeef' * 8
      end.converge(described_recipe)
    end

    it 'fetches the exporter' do
      expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/nginx-prometheus-exporter.tar.gz")
    end

    it 'renders the systemd unit' do
      expect(chef_run).to create_template('/etc/systemd/system/nginx-prometheus-exporter.service').with(mode: '0644')
    end

    it 'enables the exporter service' do
      expect(chef_run).to enable_service('nginx-prometheus-exporter')
    end
  end
end
