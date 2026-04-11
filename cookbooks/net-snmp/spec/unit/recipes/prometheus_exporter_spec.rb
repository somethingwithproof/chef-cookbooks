# frozen_string_literal: true

require 'spec_helper'

describe 'net-snmp::prometheus_exporter' do
  context 'without a checksum configured' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04').converge(described_recipe)
    end

    it 'refuses to converge' do
      expect { chef_run }.to raise_error(/checksum/)
    end
  end

  context 'with a checksum configured' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['net_snmp']['prometheus']['checksum'] = 'deadbeef' * 8
      end.converge(described_recipe)
    end

    it 'converges' do
      expect { chef_run }.not_to raise_error
    end

    it 'creates the exporter system group' do
      expect(chef_run).to create_group('snmp_exporter').with(system: true)
    end

    it 'creates the exporter system user' do
      expect(chef_run).to create_user('snmp_exporter').with(system: true, shell: '/sbin/nologin')
    end

    it 'creates the config directory' do
      expect(chef_run).to create_directory('/etc/snmp_exporter')
    end

    it 'renders snmp.yml with mode 0640 and sensitive' do
      expect(chef_run).to create_template('/etc/snmp_exporter/snmp.yml').with(mode: '0640', sensitive: true)
    end

    it 'creates the systemd unit' do
      expect(chef_run).to create_systemd_unit('snmp_exporter.service')
    end

    it 'enables the snmp_exporter service' do
      expect(chef_run).to enable_service('snmp_exporter')
    end
  end
end
