require 'spec_helper'

describe 'r_package' do
  step_into :r_package
  platform 'ubuntu'

  context 'install action' do
    recipe do
      r_package 'dplyr' do
        action :install
      end
    end

    it 'creates the R script template' do
      expect(chef_run).to create_template("#{Chef::Config[:file_cache_path]}/install_dplyr.R").with(
        cookbook: 'r-language',
        source: 'r_package_install.R.erb',
        owner: 'root',
        group: 'root',
        mode: '0755',
        variables: {
          package_name: 'dplyr',
          version: nil,
          repo: 'https://cloud.r-project.org',
          bioc: false
        }
      )
    end

    it 'runs Rscript to install the package' do
      expect(chef_run).to run_execute('install_r_package_dplyr').with(
        command: "/usr/bin/Rscript #{Chef::Config[:file_cache_path]}/install_dplyr.R"
      )
    end
  end

  context 'install action with version' do
    recipe do
      r_package 'dplyr' do
        version '1.0.0'
        action :install
      end
    end

    it 'creates the R script template with version' do
      expect(chef_run).to create_template("#{Chef::Config[:file_cache_path]}/install_dplyr.R").with(
        variables: {
          package_name: 'dplyr',
          version: '1.0.0',
          repo: 'https://cloud.r-project.org',
          bioc: false
        }
      )
    end
  end

  context 'install action with custom repo' do
    recipe do
      r_package 'dplyr' do
        repo 'https://cran.rstudio.com'
        action :install
      end
    end

    it 'creates the R script template with custom repo' do
      expect(chef_run).to create_template("#{Chef::Config[:file_cache_path]}/install_dplyr.R").with(
        variables: {
          package_name: 'dplyr',
          version: nil,
          repo: 'https://cran.rstudio.com',
          bioc: false
        }
      )
    end
  end

  context 'install action for Bioconductor package' do
    recipe do
      r_package 'DESeq2' do
        bioc true
        action :install
      end
    end

    it 'creates the R script template for Bioconductor' do
      expect(chef_run).to create_template("#{Chef::Config[:file_cache_path]}/install_DESeq2.R").with(
        variables: {
          package_name: 'DESeq2',
          version: nil,
          repo: 'https://cloud.r-project.org',
          bioc: true
        }
      )
    end
  end

  context 'remove action' do
    recipe do
      r_package 'dplyr' do
        action :remove
      end
    end

    it 'creates the R script to remove the package' do
      expect(chef_run).to create_file("#{Chef::Config[:file_cache_path]}/remove_dplyr.R").with(
        mode: '0755'
      )
    end

    it 'runs Rscript to remove the package' do
      expect(chef_run).to run_execute('remove_r_package_dplyr').with(
        command: "/usr/bin/Rscript #{Chef::Config[:file_cache_path]}/remove_dplyr.R"
      )
    end
  end
end