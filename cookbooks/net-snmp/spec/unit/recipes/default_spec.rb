# frozen_string_literal: true

require 'spec_helper'

describe 'net-snmp::default' do
  SUPPORTED_PLATFORMS.each do |p|
    context "on #{p[:platform]} #{p[:version]}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: p[:platform], version: p[:version]).converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.not_to raise_error
      end

      it 'enables and starts snmpd' do
        expect(chef_run).to enable_service('snmpd')
        expect(chef_run).to start_service('snmpd')
      end
    end
  end

  context 'package installation on debian family' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04').converge(described_recipe)
    end

    it 'installs snmp, snmpd, snmp-mibs-downloader' do
      expect(chef_run).to install_package(%w(snmp snmpd snmp-mibs-downloader))
    end
  end

  context 'package installation on rhel family' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'rocky', version: '9').converge(described_recipe)
    end

    it 'installs net-snmp and net-snmp-utils' do
      expect(chef_run).to install_package(%w(net-snmp net-snmp-utils))
    end
  end

  context 'with a banned community string' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['net_snmp']['community_strings'] = [{ 'community' => 'public', 'source' => '10.0.0.0/8' }]
      end.converge(described_recipe)
    end

    it 'refuses to converge' do
      expect { chef_run }.to raise_error(NetSnmp::Security::InsecureCommunityError)
    end
  end

  context 'with SNMPv3 users configured' do
    before do
      stub_command("grep -q 'usmUser.*testuser' /var/lib/snmp/snmpd.conf 2>/dev/null").and_return(false)
    end

    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['net_snmp']['v3_users'] = [
          {
            'username' => 'testuser',
            'auth_protocol' => 'SHA',
            'auth_password' => 'authpass123456',
            'priv_protocol' => 'AES',
            'priv_password' => 'privpass123456',
          },
        ]
      end.converge(described_recipe)
    end

    it 'creates snmpd.conf.d directory' do
      expect(chef_run).to create_directory('/etc/snmp/snmpd.conf.d')
    end

    it 'renders snmpd.conf with mode 0600' do
      expect(chef_run).to create_template('/etc/snmp/snmpd.conf').with(mode: '0600', sensitive: true)
    end

    it 'notifies snmpd to restart on config change' do
      template = chef_run.template('/etc/snmp/snmpd.conf')
      expect(template).to notify('service[snmpd]').to(:restart).delayed
    end

    it 'creates the SNMPv3 user execute resource' do
      expect(chef_run).to run_execute('create_snmpv3_user_testuser')
    end
  end

  context 'without SNMPv3 users configured' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['net_snmp']['v3_users'] = []
      end.converge(described_recipe)
    end

    it 'does not render snmpd.conf' do
      expect(chef_run).not_to create_template('/etc/snmp/snmpd.conf')
    end
  end
end
