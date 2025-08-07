require 'spec_helper'

describe 'net-snmp::default' do
  context 'on ubuntu 22.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        # Set any attributes you need
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
        # Set any attributes you need
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
end

