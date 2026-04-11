require 'spec_helper'

describe 'r-language::source' do
  context 'on ubuntu platform' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04') do |node|
        node.normal['r-language']['version'] = '4.3.1'
      end.converge(described_recipe)
    end

    before(:each) do
      stub_commands
      allow(::File).to receive(:exist?).and_call_original
      allow(::File).to receive(:exist?).with('/usr/local/bin/R').and_return(false)
    end

    it 'includes the build-essential recipe' do
      expect(chef_run).to install_build_essential('install compilation tools')
    end

    it 'installs required build dependencies' do
      expect(chef_run).to install_package(%w(
                                            gfortran libblas-dev liblapack-dev libpcre2-dev libcurl4-openssl-dev
                                            libbz2-dev liblzma-dev libreadline-dev xorg-dev libcairo2-dev
                                            libpango1.0-dev libjpeg-dev libpng-dev libxml2-dev
                                          ))
    end

    it 'executes extract_r_source' do
      expect(chef_run).to run_execute('extract_r_source')
    end

    it 'executes build_r' do
      expect(chef_run).to run_execute('build_r')
    end

    it 'executes install_r' do
      expect(chef_run).to run_execute('install_r')
    end
  end

  context 'on centos platform' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '8') do |node|
        node.normal['r-language']['version'] = '4.3.1'
      end.converge(described_recipe)
    end

    before(:each) do
      stub_commands
      allow(::File).to receive(:exist?).and_call_original
      allow(::File).to receive(:exist?).with('/usr/local/bin/R').and_return(false)
    end

    it 'installs required build dependencies for RHEL-based systems' do
      expect(chef_run).to install_package(%w(
                                            gcc-gfortran blas-devel lapack-devel pcre2-devel libcurl-devel
                                            bzip2-devel xz-devel readline-devel libXt-devel cairo-devel
                                            pango-devel libjpeg-devel libpng-devel libxml2-devel
                                          ))
    end
  end

  context 'when R is already installed' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04') do |node|
        node.normal['r-language']['version'] = '4.3.1'
      end.converge(described_recipe)
    end

    before(:each) do
      stub_commands
      allow(::File).to receive(:exist?).and_call_original
      allow(::File).to receive(:exist?).with('/usr/local/bin/R').and_return(true)
    end

    it 'does not extract R source' do
      expect(chef_run).not_to run_execute('extract_r_source')
    end

    it 'does not build R' do
      expect(chef_run).not_to run_execute('build_r')
    end

    it 'does not install R' do
      expect(chef_run).not_to run_execute('install_r')
    end
  end
end
