require 'spec_helper'

describe 'snmp::snmptrapd' do
  PLATFORMS.each do |platform_name, platform_info|
    context "on #{platform_name}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: platform_info[:platform],
          version: platform_info[:version]
        ) do |node|
          node.override['snmp']['community'] = 'spec-ro-community'
          node.override['snmp']['trap']['community'] = 'spec-trap-community'
          node.override['snmp']['snmptrapd']['service'] = platform_info[:platform_family] == 'rhel' ? 'snmptrapd' : 'snmpd'
        end.converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'configures snmp_trapd with the explicit trap community' do
        expect(chef_run).to install_snmp_trapd('default').with(
          trap_community: 'spec-trap-community',
          trap_port: 162
        )
      end
    end
  end
end
