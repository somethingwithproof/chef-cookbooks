#
# Cookbook:: r-language
# Recipe:: source
#
# Copyright:: 2025, Thomas Vincent
#
# Installs R programming language from source

build_essential 'install compilation tools'

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

# Download R source tarball
source_tarball = "#{Chef::Config[:file_cache_path]}/r-#{r_version}.tar.gz"
source_dir = "#{Chef::Config[:file_cache_path]}/R-#{r_version}"

remote_file source_tarball do
  source r_url
  checksum r_checksum if r_checksum
  mode '0644'
  action :create
  not_if { r_installed_at_version?(r_version) }
end

# Extract R source code
execute 'extract_r_source' do
  command "tar -xzf #{source_tarball} -C #{Chef::Config[:file_cache_path]}"
  creates source_dir
  not_if { r_installed_at_version?(r_version) }
end

# Configure R
execute 'configure_r' do
  command "./configure #{node['r-language']['source']['configure_options'].join(' ')}"
  cwd source_dir
  creates "#{source_dir}/config.status"
  not_if { r_installed_at_version?(r_version) }
end

# Build R
execute 'build_r' do
  command 'make'
  cwd source_dir
  creates "#{source_dir}/bin/R"
  not_if { r_installed_at_version?(r_version) }
end

# Install R
execute 'install_r' do
  command 'make install'
  cwd source_dir
  creates '/usr/local/bin/R'
  not_if { r_installed_at_version?(r_version) }
end

# Clean up source files
file source_tarball do
  action :delete
  only_if { ::File.exist?('/usr/local/bin/R') }
end

directory source_dir do
  recursive true
  action :delete
  only_if { ::File.exist?('/usr/local/bin/R') }
end

# Helper method to check if R is installed at the desired version. Uses the
# array form of shell_out so the version string is never interpolated into a
# shell command line.
def r_installed_at_version?(version)
  return false unless ::File.exist?('/usr/local/bin/R')

  cmd = shell_out('/usr/local/bin/R', '--version')
  return false unless cmd.exitstatus.zero?

  cmd.stdout.match?(/R version #{Regexp.escape(version)}/)
end
