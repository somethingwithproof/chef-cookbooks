require 'spec_helper'

describe 'snmp_trapd' do
  PLATFORMS.each do |platform_name, platform_info|
    context "on #{platform_name}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: platform_info[:platform],
          version: platform_info[:version],
          step_into: ['snmp_trapd']
        ) do |node|
          node.override['snmp']['community'] = 'spec-ro-community'
          node.override['snmp']['trap']['community'] = 'spec-trap-community'
        end.converge('snmp::snmptrapd')
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'writes snmptrapd.conf with mode 0600 and root ownership' do
        expect(chef_run).to create_template('/etc/snmp/snmptrapd.conf').with(
          mode: '0600',
          owner: 'root',
          group: 'root',
          sensitive: true
        )
      end

      it 'enables and starts the SNMP trap service' do
        if platform_info[:platform_family] == 'rhel'
          expect(chef_run).to start_service('snmptrapd')
          expect(chef_run).to enable_service('snmptrapd')
        else
          expect(chef_run).to start_service('snmpd')
          expect(chef_run).to enable_service('snmpd')
        end
      end

      it 'refuses to converge with a "public" trap community' do
        bad = ChefSpec::SoloRunner.new(
          platform: platform_info[:platform],
          version: platform_info[:version],
          step_into: ['snmp_trapd']
        ) do |node|
          node.override['snmp']['community'] = 'spec-ro-community'
          node.override['snmp']['trap']['community'] = 'public'
        end
        expect { bad.converge('snmp::snmptrapd') }.to raise_error(/public.*private/)
      end
    end
  end
end
