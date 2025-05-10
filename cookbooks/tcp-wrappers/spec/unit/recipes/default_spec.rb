require 'spec_helper'

describe 'tcp_wrappers::default' do
  context 'When all attributes are default, on Ubuntu 22.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        # No need to set attributes, platform detection will happen automatically
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs the package based on platform detection' do
      expect(chef_run).to install_package('tcpd')
    end

    it 'creates the wrappers.d directory' do
      expect(chef_run).to create_directory('/etc/wrappers.d')
    end

    it 'creates the hosts.allow file' do
      expect(chef_run).to create_template_if_missing('/etc/hosts.allow')
    end
  end

  context 'When all attributes are default, on Ubuntu 20.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04').converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs the tcp_wrappers package' do
      expect(chef_run).to install_package('tcp_wrappers')
    end
  end

  context 'When all attributes are default, on AlmaLinux 9' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'almalinux', version: '9').converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
    
    it 'installs the tcp_wrappers package' do
      expect(chef_run).to install_package('tcp_wrappers')
    end
  end
  
  context 'with custom attributes' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.override['authorization']['tcp_wrappers']['include_wrappers_d'] = false
      end.converge(described_recipe)
    end
    
    it 'does not create the hosts.allow template' do
      expect(chef_run).not_to create_template_if_missing('/etc/hosts.allow')
    end
  end
end