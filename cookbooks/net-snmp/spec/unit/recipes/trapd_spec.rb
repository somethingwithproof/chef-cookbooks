# frozen_string_literal: true

require 'spec_helper'

describe 'net-snmp::trapd' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: ['snmp_trap_receiver']) do |node|
      node.normal['net_snmp']['trapd']['log_type'] = 'file'
      node.normal['net_snmp']['trapd']['log_file'] = '/var/log/snmptrapd.log'
      node.normal['net_snmp']['trapd']['handlers'] = [
        { 'name' => 'disk_alert', 'action' => 'email', 'email_to' => 'ops@example.com', 'oid_filter' => '.1.3.6.1.4.1.2021' },
      ]
    end.converge(described_recipe)
  end

  it 'converges' do
    expect { chef_run }.not_to raise_error
  end

  it 'creates the snmp_trap_receiver resource' do
    expect(chef_run).to create_snmp_trap_receiver('default')
  end

  it 'creates the log directory when logging to a file' do
    expect(chef_run).to create_directory('/var/log').with(mode: '0755')
  end

  it 'creates the handler directory' do
    expect(chef_run).to create_directory('/usr/local/bin/snmp-handlers').with(mode: '0755')
  end

  it 'rejects a banned trap community string' do
    expect do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: ['snmp_trap_receiver']) do |node|
        node.normal['net_snmp']['trapd']['community'] = 'public'
      end.converge(described_recipe)
    end.to raise_error(NetSnmp::Security::InsecureCommunityError)
  end
end
