require 'spec_helper'

describe 'snmp::snmptrapd' do
  PLATFORMS.each do |platform_name, platform_info|
    context "on #{platform_name}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: platform_info[:platform],
          version: platform_info[:version]
        ).converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'includes the snmp_trapd resource with default attributes' do
        expect(chef_run).to install_snmp_trapd('default').with(
          trap_community: 'public',
          trap_port: 162
        )
      end
    end
  end
end
