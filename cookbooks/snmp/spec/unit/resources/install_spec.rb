require 'spec_helper'

describe 'snmp_install' do
  PLATFORMS.each do |platform_name, platform_info|
    context "on #{platform_name}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: platform_info[:platform],
          version: platform_info[:version],
          step_into: ['snmp_install']
        ).converge('snmp::default')
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'installs the SNMP package' do
        if platform_info[:platform_family] == 'debian'
          expect(chef_run).to install_package('snmpd')
        else
          expect(chef_run).to install_package('net-snmp')
        end
      end

      it 'creates the SNMP service with proper action' do
        expect(chef_run).to start_service('snmpd')
        expect(chef_run).to enable_service('snmpd')
      end

      it 'creates the SNMP configuration file' do
        expect(chef_run).to create_template('/etc/snmp/snmpd.conf')
      end

      if platform_info[:platform_family] == 'debian'
        it 'creates the Debian SNMP configuration file' do
          expect(chef_run).to create_template('/etc/default/snmpd')
        end
      end
    end
  end
end
