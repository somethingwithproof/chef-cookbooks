#
# Cookbook:: r-language
# Recipe:: packages
#
# Copyright:: 2025, Thomas Vincent
#
# Installs R packages

# SECURITY: enforce https on the CRAN mirror -- the install scripts download
# and execute arbitrary R code from this URL.
cran_mirror = node['r-language']['cran_mirror'].to_s
unless cran_mirror.start_with?('https://')
  raise "r-language: node['r-language']['cran_mirror'] must use https (got #{cran_mirror.inspect})"
end

script_path = "#{Chef::Config[:file_cache_path]}/install_r_packages.R"

# Create Rscript template to install packages with proper error handling
template script_path do
  source 'install_packages.R.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(
    cran_mirror: cran_mirror,
    packages: node['r-language']['packages']
  )
  action :create
end

# Execute the R script to install packages. Array form avoids shell expansion
# and any quoting concerns around the cache path.
execute 'install_r_packages' do
  command ['/usr/bin/Rscript', script_path]
  action :run
  not_if { node['r-language']['packages'].empty? }
end
