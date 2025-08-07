require 'spec_helper'

describe 'net-snmp::default' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '22.04') do |node|
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
