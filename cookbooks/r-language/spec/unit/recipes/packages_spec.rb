require 'spec_helper'

describe 'r-language::packages' do
  context 'with packages defined' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['r-language']['packages'] = ['dplyr', 'ggplot2']
        node.normal['r-language']['cran_mirror'] = 'https://cloud.r-project.org'
      end.converge(described_recipe)
    end

    it 'creates the install_r_packages.R template' do
      expect(chef_run).to create_template("#{Chef::Config[:file_cache_path]}/install_r_packages.R").with(
        source: 'install_packages.R.erb',
        owner: 'root',
        group: 'root',
        mode: '0755',
        variables: {
          cran_mirror: 'https://cloud.r-project.org',
          packages: ['dplyr', 'ggplot2']
        }
      )
    end

    it 'executes the R script to install packages' do
      expect(chef_run).to run_execute('install_r_packages').with(
        command: "/usr/bin/Rscript #{Chef::Config[:file_cache_path]}/install_r_packages.R"
      )
    end
  end

  context 'with no packages defined' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['r-language']['packages'] = []
      end.converge(described_recipe)
    end

    it 'creates the install_r_packages.R template' do
      expect(chef_run).to create_template("#{Chef::Config[:file_cache_path]}/install_r_packages.R")
    end

    it 'does not execute the R script to install packages' do
      expect(chef_run).not_to run_execute('install_r_packages')
    end
  end

  context 'with custom CRAN mirror' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['r-language']['packages'] = ['dplyr']
        node.normal['r-language']['cran_mirror'] = 'https://cran.rstudio.com'
      end.converge(described_recipe)
    end

    it 'creates the install_r_packages.R template with custom mirror' do
      expect(chef_run).to create_template("#{Chef::Config[:file_cache_path]}/install_r_packages.R").with(
        variables: {
          cran_mirror: 'https://cran.rstudio.com',
          packages: ['dplyr']
        }
      )
    end
  end
end