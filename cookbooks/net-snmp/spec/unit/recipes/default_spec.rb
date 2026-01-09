# frozen_string_literal: true

require 'spec_helper'

describe 'net-snmp::default' do
  context 'on ubuntu 22.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['net-snmp']['snmpv3']['enabled'] = false
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs snmp package' do
      expect(chef_run).to install_package('snmp')
    end

    it 'installs snmpd package' do
      expect(chef_run).to install_package('snmpd')
    end

    it 'enables and starts snmpd service' do
      expect(chef_run).to enable_service('snmpd')
      expect(chef_run).to start_service('snmpd')
    end
  end

  context 'on centos 8' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '8') do |node|
        node.normal['net-snmp']['snmpv3']['enabled'] = false
      end.converge(described_recipe)
    end

    it 'installs net-snmp package for client utilities' do
      expect(chef_run).to install_package('net-snmp')
    end

    it 'does not install net-snmp-agent-libs package' do
      expect(chef_run).to_not install_package('net-snmp-agent-libs')
    end

    it 'enables and starts snmpd service' do
      expect(chef_run).to enable_service('snmpd')
      expect(chef_run).to start_service('snmpd')
    end
  end

  context 'with SNMPv3 enabled on ubuntu 22.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['net-snmp']['snmpv3']['enabled'] = true
        node.normal['net-snmp']['snmpv3']['users'] = [
          {
            'username' => 'testuser',
            'auth_protocol' => 'SHA',
            'auth_password' => 'authpass123456',
            'priv_protocol' => 'AES',
            'priv_password' => 'privpass123456',
          },
        ]
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates snmpd.conf template' do
      expect(chef_run).to create_template('/etc/snmp/snmpd.conf')
    end

    it 'restarts snmpd service when config changes' do
      template = chef_run.template('/etc/snmp/snmpd.conf')
      expect(template).to notify('service[snmpd]').to(:restart).delayed
    end
  end
end
