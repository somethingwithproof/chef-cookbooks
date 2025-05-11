require 'spec_helper'

describe 'r-language::package' do
  context 'on ubuntu platform' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04') do |node|
        node.normal['lsb']['codename'] = 'focal'
        node.normal['r-language']['enable_repo'] = true
        node.normal['r-language']['install_dev'] = true
        node.normal['r-language']['install_recommended'] = true
      end.converge(described_recipe)
    end

    it 'installs apt-transport-https' do
      expect(chef_run).to install_package('apt-transport-https')
    end

    it 'adds the r-project apt repository' do
      expect(chef_run).to add_apt_repository('r-project').with(
        uri: 'https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/',
        key: 'E298A3A825C0D65DFD57CBB651716619E084DAB9'
      )
    end

    it 'installs r-base package' do
      expect(chef_run).to install_package('r-base')
    end

    it 'installs r-base-dev package' do
      expect(chef_run).to install_package('r-base-dev')
    end

    it 'installs r-recommended package' do
      expect(chef_run).to install_package('r-recommended')
    end
  end

  context 'on debian platform' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'debian', version: '10') do |node|
        node.normal['lsb']['codename'] = 'buster'
        node.normal['r-language']['enable_repo'] = true
      end.converge(described_recipe)
    end

    it 'adds the r-project apt repository with correct debian settings' do
      expect(chef_run).to add_apt_repository('r-project').with(
        uri: 'https://cloud.r-project.org/bin/linux/debian buster-cran40/',
        key: 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'
      )
    end
  end

  context 'on centos platform' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '8') do |node|
        node.normal['r-language']['enable_repo'] = true
      end.converge(described_recipe)
    end

    it 'creates the epel yum repository' do
      expect(chef_run).to create_yum_repository('epel')
    end

    it 'installs R package' do
      expect(chef_run).to install_package('R')
    end
  end

  context 'with specific version on ubuntu' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04') do |node|
        node.normal['lsb']['codename'] = 'focal'
        node.normal['r-language']['version'] = '4.0.2'
      end.converge(described_recipe)
    end

    it 'installs r-base package with specific version' do
      expect(chef_run).to install_package('r-base').with(version: '4.0.2')
    end
  end

  context 'with repo disabled on ubuntu' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04') do |node|
        node.normal['lsb']['codename'] = 'focal'
        node.normal['r-language']['enable_repo'] = false
      end.converge(described_recipe)
    end

    it 'does not add the r-project apt repository' do
      expect(chef_run).not_to add_apt_repository('r-project')
    end

    it 'installs r-base package' do
      expect(chef_run).to install_package('r-base')
    end
  end
end