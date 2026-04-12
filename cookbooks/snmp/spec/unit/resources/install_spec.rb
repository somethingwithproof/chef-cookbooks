require 'spec_helper'

describe 'snmp_install' do
  PLATFORMS.each do |platform_name, platform_info|
    context "on #{platform_name}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: platform_info[:platform],
          version: platform_info[:version],
          step_into: ['snmp_install']
        ) do |node|
          node.override['snmp']['community'] = 'spec-ro-community'
          node.override['snmp']['trap']['community'] = 'spec-trap-community'
        end.converge('snmp::default')
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

      it 'writes snmpd.conf with mode 0600 and root ownership' do
        expect(chef_run).to create_template('/etc/snmp/snmpd.conf').with(
          mode: '0600',
          owner: 'root',
          group: 'root',
          sensitive: true
        )
      end

      it 'refuses to converge if a sec_name source is the all-hosts wildcard' do
        bad = ChefSpec::SoloRunner.new(
          platform: platform_info[:platform],
          version: platform_info[:version],
          step_into: ['snmp_install']
        ) do |node|
          node.override['snmp']['community'] = 'spec-ro-community'
          node.override['snmp']['trap']['community'] = 'spec-trap-community'
          node.override['snmp']['sec_name'] = { notConfigUser: %w(default) }
        end
        expect { bad.converge('snmp::default') }.to raise_error(/wildcard source/)
      end

      if platform_info[:platform_family] == 'debian'
        it 'creates the Debian SNMP configuration file' do
          expect(chef_run).to create_template('/etc/default/snmpd')
        end
      end
    end
  end
end
