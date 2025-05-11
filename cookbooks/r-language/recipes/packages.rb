#
# Cookbook:: r-language
# Recipe:: packages
#
# Copyright:: 2025, Thomas Vincent
#
# Installs R packages

# Create Rscript template to install packages with proper error handling
template "#{Chef::Config[:file_cache_path]}/install_r_packages.R" do
  source 'install_packages.R.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(
    cran_mirror: node['r-language']['cran_mirror'],
    packages: node['r-language']['packages']
  )
  action :create
end

# Execute the R script to install packages
execute 'install_r_packages' do
  command "/usr/bin/Rscript #{Chef::Config[:file_cache_path]}/install_r_packages.R"
  action :run
  not_if { node['r-language']['packages'].empty? }
end