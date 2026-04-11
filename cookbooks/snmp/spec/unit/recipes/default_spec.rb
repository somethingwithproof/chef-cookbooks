require 'spec_helper'

describe 'snmp::default' do
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

      it 'includes the snmp_install resource with default attributes' do
        expect(chef_run).to install_snmp_install('default').with(
          community: 'public',
          trap_community: 'public',
          trap_port: 162
        )
      end
    end
  end
end
