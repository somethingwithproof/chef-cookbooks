# frozen_string_literal: true

require 'spec_helper'

describe 'zabbix::agent' do
  context 'on Ubuntu 22.04' do
    platform 'ubuntu', '22.04'

    before do
      stub_command('getenforce | grep -i disabled').and_return(true)
    end

    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['zabbix']['agent']['enabled'] = true
        node.normal['zabbix']['agent']['hostname'] = 'test-host'
        node.normal['zabbix']['agent']['servers'] = ['127.0.0.1']
        node.normal['zabbix']['agent']['servers_active'] = ['127.0.0.1']
        node.normal['zabbix']['server']['enabled'] = false
        node.normal['zabbix']['web']['enabled'] = false
      end
      runner.converge(described_recipe)
    end

    it 'installs the zabbix_agent resource' do
      expect(chef_run).to install_zabbix_agent('zabbix_agent')
    end

    it 'renders zabbix_agentd.conf as root:zabbix mode 0640' do
      expect(chef_run).to create_template('/etc/zabbix/zabbix_agentd.conf').with(
        owner: 'root',
        group: 'zabbix',
        mode: '0640',
        sensitive: true
      )
    end

    it 'never enables remote commands by default' do
      # The default attribute is 0 / DenyKey=system.run[*]. The cookbook
      # forbids server-driven shell execution unless an operator opts in.
      expect(chef_run.node['zabbix']['agent']['enable_remote_commands'].to_i).to eq(0)
    end
  end
end
