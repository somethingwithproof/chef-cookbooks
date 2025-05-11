require 'spec_helper'

describe 'r-language::source' do
  context 'on ubuntu platform' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04') do |node|
        node.normal['r-language']['version'] = '4.3.1'
      end.converge(described_recipe)
    end

    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/usr/local/bin/R').and_return(false)
    end

    it 'includes the build-essential recipe' do
      expect(chef_run).to include_recipe('build-essential')
    end

    it 'installs required build dependencies' do
      %w(
        gfortran libblas-dev liblapack-dev libpcre2-dev libcurl4-openssl-dev
        libbz2-dev liblzma-dev libreadline-dev xorg-dev libcairo2-dev
        libpango1.0-dev libjpeg-dev libpng-dev libxml2-dev
      ).each do |pkg|
        expect(chef_run).to install_package(pkg)
      end
    end

    it 'executes extract_r_source' do
      expect(chef_run).to run_bash('extract_r_source')
    end

    it 'executes build_and_install_r' do
      expect(chef_run).to run_bash('build_and_install_r')
    end

    it 'deletes the source tarball' do
      expect(chef_run).to delete_file('/tmp/r-4.3.1.tar.gz')
    end

    it 'deletes the source directory' do
      expect(chef_run).to delete_directory('/tmp/R-4.3.1').with(recursive: true)
    end
  end

  context 'on centos platform' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '8') do |node|
        node.normal['r-language']['version'] = '4.3.1'
      end.converge(described_recipe)
    end

    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/usr/local/bin/R').and_return(false)
    end

    it 'installs required build dependencies for RHEL-based systems' do
      %w(
        gcc-gfortran blas-devel lapack-devel pcre2-devel libcurl-devel
        bzip2-devel xz-devel readline-devel libXt-devel cairo-devel
        pango-devel libjpeg-devel libpng-devel libxml2-devel
      ).each do |pkg|
        expect(chef_run).to install_package(pkg)
      end
    end
  end

  context 'when R is already installed' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04') do |node|
        node.normal['r-language']['version'] = '4.3.1'
      end.converge(described_recipe)
    end

    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/usr/local/bin/R').and_return(true)
      allow_any_instance_of(Chef::Resource::Bash).to receive(:not_if).and_yield
      allow(Mixlib::ShellOut).to receive(:new).with('/usr/local/bin/R --version').and_return(
        double(run_command: nil, stdout: 'R version 4.3.1', stderr: '')
      )
    end

    it 'does not extract R source' do
      expect(chef_run).not_to run_bash('extract_r_source')
    end

    it 'does not build and install R' do
      expect(chef_run).not_to run_bash('build_and_install_r')
    end
  end
end