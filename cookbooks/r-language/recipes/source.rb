#
# Cookbook:: r-language
# Recipe:: source
#
# Copyright:: 2025, Thomas Vincent
#
# Installs R programming language from source

include_recipe 'build-essential'

# Install build dependencies
case node['platform_family']
when 'debian'
  package %w(
    gfortran
    libblas-dev
    liblapack-dev
    libpcre2-dev
    libcurl4-openssl-dev
    libbz2-dev
    liblzma-dev
    libreadline-dev
    xorg-dev
    libcairo2-dev
    libpango1.0-dev
    libjpeg-dev
    libpng-dev
    libxml2-dev
  ) do
    action :install
  end
when 'rhel', 'fedora', 'amazon'
  package %w(
    gcc-gfortran
    blas-devel
    lapack-devel
    pcre2-devel
    libcurl-devel
    bzip2-devel
    xz-devel
    readline-devel
    libXt-devel
    cairo-devel
    pango-devel
    libjpeg-devel
    libpng-devel
    libxml2-devel
  ) do
    action :install
  end
else
  Chef::Log.warn("Unsupported platform family: #{node['platform_family']}")
end

# Set the R version and url
r_version = node['r-language']['version'] || '4.3.1'
r_url = node['r-language']['source_url'] || "https://cran.r-project.org/src/base/R-#{r_version.split('.').first}/R-#{r_version}.tar.gz"
r_checksum = node['r-language']['source_checksum']

# Download and extract R source code
source_dir = "/tmp/R-#{r_version}"
bash "extract_r_source" do
  cwd "/tmp"
  code <<-EOH
    curl -sSL #{r_url} -o r-#{r_version}.tar.gz
    tar -xzf r-#{r_version}.tar.gz
  EOH
  not_if { ::File.exist?("/usr/local/bin/R") && `/usr/local/bin/R --version`.include?(r_version) }
end

# Configure and build R
bash "build_and_install_r" do
  cwd source_dir
  code <<-EOH
    ./configure #{node['r-language']['source']['configure_options'].join(' ')}
    make
    make install
  EOH
  not_if { ::File.exist?("/usr/local/bin/R") && `/usr/local/bin/R --version`.include?(r_version) }
end

# Clean up source files
file "/tmp/r-#{r_version}.tar.gz" do
  action :delete
end

directory source_dir do
  recursive true
  action :delete
end