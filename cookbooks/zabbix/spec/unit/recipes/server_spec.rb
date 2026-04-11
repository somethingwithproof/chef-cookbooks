# frozen_string_literal: true

require 'spec_helper'

describe 'zabbix::server' do
  context 'when database_password is missing' do
    platform 'ubuntu', '22.04'

    before do
      stub_command('getenforce | grep -i disabled').and_return(true)
      stub_command('test -f /usr/sbin/zabbix_server').and_return(false)
      stub_command(/psql -tAc/).and_return(false)
      stub_command(/grep -q/).and_return(false)
    end

    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['zabbix']['server']['enabled'] = true
        node.normal['zabbix']['server']['database']['password'] = nil
      end
      runner.converge(described_recipe)
    end

    it 'fails closed before any package install' do
      # The recipe fails inside the database recipe (which runs before the
      # zabbix_server resource) because the database password is the first
      # secret it touches.
      expect { chef_run }.to raise_error(/password.*required/i)
    end
  end

  context 'with a vault-supplied password on Ubuntu 22.04' do
    platform 'ubuntu', '22.04'

    before do
      stub_command('getenforce | grep -i disabled').and_return(true)
      stub_command('test -f /usr/sbin/zabbix_server').and_return(false)
      stub_command(/psql -tAc/).and_return(false)
      stub_command(/grep -q/).and_return(false)
    end

    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['zabbix']['server']['enabled'] = true
        node.normal['zabbix']['server']['database']['type'] = 'postgresql'
        node.normal['zabbix']['server']['database']['password'] = 's3cret-from-vault'
        node.normal['zabbix']['agent']['enabled'] = true
        node.normal['zabbix']['web']['enabled'] = false
      end
      runner.converge(described_recipe)
    end

    it 'installs the zabbix_server resource' do
      expect(chef_run).to install_zabbix_server('zabbix_server')
    end

    it 'renders zabbix_server.conf with mode 0640 and group zabbix' do
      expect(chef_run).to create_template('/etc/zabbix/zabbix_server.conf').with(
        owner: 'root',
        group: 'zabbix',
        mode: '0640',
        sensitive: true
      )
    end
  end
end
