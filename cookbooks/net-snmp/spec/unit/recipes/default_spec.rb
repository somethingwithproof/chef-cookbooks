# frozen_string_literal: true

require 'spec_helper'

describe 'net-snmp::default' do
  context 'on ubuntu 22.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04').converge(described_recipe)
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
      ChefSpec::SoloRunner.new(platform: 'centos', version: '8').converge(described_recipe)
    end

    it 'installs net-snmp package for client utilities' do
      expect(chef_run).to install_package('net-snmp')
    end

    it 'installs net-snmp-utils package' do
      expect(chef_run).to install_package('net-snmp-utils')
    end

    it 'enables and starts snmpd service' do
      expect(chef_run).to enable_service('snmpd')
      expect(chef_run).to start_service('snmpd')
    end
  end

  context 'with SNMPv3 users configured on ubuntu 22.04' do
    before do
      stub_command("grep -q 'usmUser.*testuser' /var/lib/snmp/snmpd.conf 2>/dev/null").and_return(false)
    end

    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['net_snmp']['v3_users'] = [
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

    it 'creates snmpd.conf.d directory' do
      expect(chef_run).to create_directory('/etc/snmp/snmpd.conf.d')
    end

    it 'creates snmpd.conf template' do
      expect(chef_run).to create_template('/etc/snmp/snmpd.conf')
    end

    it 'restarts snmpd service when config changes' do
      template = chef_run.template('/etc/snmp/snmpd.conf')
      expect(template).to notify('service[snmpd]').to(:restart).delayed
    end

    it 'creates SNMPv3 user' do
      expect(chef_run).to run_execute('create_snmpv3_user_testuser')
    end
  end

  context 'without SNMPv3 users on ubuntu 22.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['net_snmp']['v3_users'] = []
      end.converge(described_recipe)
    end

    it 'does not create snmpd.conf template when no v3 users' do
      expect(chef_run).to_not create_template('/etc/snmp/snmpd.conf')
    end
  end
end
