#
# Cookbook:: r-language
# Recipe:: package
#
# Copyright:: 2025, Thomas Vincent
#
# Installs R programming language using platform package managers

platform_family = node['platform_family']

case platform_family
when 'debian'
  # Set up R repository
  if node['r-language']['enable_repo']
    apt_update 'update' do
      action :nothing
    end

    # Install required packages for apt repository management
    %w(apt-transport-https ca-certificates gnupg).each do |pkg|
      package pkg do
        action :install
      end
    end

    # Determine which repository to use
    codename = node['lsb']['codename']
    if platform?('ubuntu')
      repo_uri = node['r-language']['ubuntu']['repo']
      repo_distribution = "#{codename}-cran40/"
      key_url = node['r-language']['ubuntu']['key_url']
    else # debian
      repo_uri = node['r-language']['debian']['repo']
      repo_distribution = "#{codename}-cran40/"
      key_url = node['r-language']['debian']['key_url']
    end

    apt_repository 'r-project' do
      uri repo_uri
      distribution repo_distribution
      key key_url
      action :add
      notifies :update, 'apt_update[update]', :immediately
    end
  end

  # Install R packages
  package 'r-base' do
    action :install
    version node['r-language']['version'] if node['r-language']['version']
  end

  if node['r-language']['install_dev']
    package 'r-base-dev' do
      action :install
    end
  end

  if node['r-language']['install_recommended']
    package 'r-recommended' do
      action :install
    end
  end

when 'rhel', 'fedora', 'amazon'
  # Set up EPEL repository if on RHEL platform and repository is enabled
  if node['r-language']['enable_repo'] && %w(rhel amazon).include?(platform_family)
    yum_repository 'epel' do
      description 'Extra Packages for Enterprise Linux'
      baseurl 'https://download.fedoraproject.org/pub/epel/$releasever/$basearch/'
      gpgkey 'https://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-$releasever'
      action :create
    end
  end

  # Install R
  package 'R' do
    action :install
    version node['r-language']['version'] if node['r-language']['version']
  end

  # Install R development packages if requested
  if node['r-language']['install_dev']
    package 'R-devel' do
      action :install
    end
  end

else
  Chef::Log.warn("Unsupported platform family: #{platform_family}")
end

# Optionally manage Renviron.site. The file is world-readable per upstream
# convention; do not write secrets through this attribute.
if node['r-language']['manage_renviron']
  template node['r-language']['renviron_path'] do
    cookbook 'r-language'
    source 'Renviron.site.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(vars: node['r-language']['renviron_vars'].to_hash)
    action :create
  end
end
