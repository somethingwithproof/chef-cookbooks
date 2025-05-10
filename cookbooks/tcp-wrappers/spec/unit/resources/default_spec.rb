require 'spec_helper'

describe 'tcp_wrappers resource' do
  context 'create action' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['tcp_wrappers']) do |node|
        node.default['authorization']['tcp_wrappers']['prefix'] = '/etc'
        node.default['authorization']['tcp_wrappers']['include_wrappers_d'] = true
      end.converge('test::default')
    end

    it 'creates the tcp_wrappers configuration' do
      expect(chef_run).to install_tcp_wrappers('sshd')
      expect(chef_run).to create_template('/etc/wrappers.d/sshd')
    end
  end

  context 'remove action' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['tcp_wrappers']) do |node|
        node.default['authorization']['tcp_wrappers']['prefix'] = '/etc'
        node.default['authorization']['tcp_wrappers']['include_wrappers_d'] = true
      end.converge('test::remove')
    end

    it 'removes the tcp_wrappers configuration' do
      expect(chef_run).to remove_tcp_wrappers('ftpd')
      expect(chef_run).to delete_file('/etc/wrappers.d/ftpd')
    end
  end
end