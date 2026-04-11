# frozen_string_literal: true

require 'spec_helper'

describe 'net-snmp::v3' do
  before do
    stub_command("grep -q 'usmUser.*opsuser' /var/lib/snmp/snmpd.conf 2>/dev/null").and_return(false)
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: ['snmp_user']) do |node|
      node.normal['net_snmp']['v3_users'] = [
        {
          'username' => 'opsuser',
          'auth_protocol' => 'SHA-256',
          'auth_password' => 'authpass12345',
          'priv_protocol' => 'AES-256',
          'priv_password' => 'privpass12345',
          'security_level' => 'authPriv',
          'access_level' => 'ro',
          'view' => 'systemview',
        },
      ]
    end.converge(described_recipe)
  end

  it 'converges' do
    expect { chef_run }.not_to raise_error
  end

  it 'creates the config include directory' do
    expect(chef_run).to create_directory('/etc/snmp/snmpd.conf.d').with(mode: '0755')
  end

  it 'delegates to snmp_user resource' do
    expect(chef_run).to create_snmp_user('opsuser')
  end
end
