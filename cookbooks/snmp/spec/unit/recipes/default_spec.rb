require 'spec_helper'

describe 'snmp::default' do
  PLATFORMS.each do |platform_name, platform_info|
    context "on #{platform_name}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: platform_info[:platform],
          version: platform_info[:version]
        ) do |node|
          node.override['snmp']['community'] = 'spec-ro-community'
          node.override['snmp']['trap']['community'] = 'spec-trap-community'
        end.converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'configures snmp_install with the explicit community strings' do
        expect(chef_run).to install_snmp_install('default').with(
          community: 'spec-ro-community',
          trap_community: 'spec-trap-community',
          trap_port: 162
        )
      end

      it 'refuses to converge when the community string is the well-known default' do
        bad = ChefSpec::SoloRunner.new(
          platform: platform_info[:platform],
          version: platform_info[:version]
        ) do |node|
          node.override['snmp']['community'] = 'public'
          node.override['snmp']['trap']['community'] = 'spec-trap-community'
        end
        expect { bad.converge(described_recipe) }.to raise_error(/public.*private/)
      end

      it 'refuses to converge when the community string is empty' do
        bad = ChefSpec::SoloRunner.new(
          platform: platform_info[:platform],
          version: platform_info[:version]
        )
        expect { bad.converge(described_recipe) }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end
end
