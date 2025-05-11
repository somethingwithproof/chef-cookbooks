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

    package 'apt-transport-https' do
      action :install
    end

    # Determine which repository to use
    if node['platform'] == 'ubuntu'
      codename = node['lsb']['codename']
      repo = "#{node['r-language']['ubuntu']['repo']} #{codename}-cran40/"
      key = node['r-language']['ubuntu']['key']
      keyserver = node['r-language']['ubuntu']['keyserver']
    else # debian
      codename = node['lsb']['codename']
      repo = "#{node['r-language']['debian']['repo']} #{codename}-cran40/"
      key = node['r-language']['debian']['key']
      keyserver = node['r-language']['debian']['keyserver']
    end

    apt_repository 'r-project' do
      uri repo
      keyserver keyserver
      key key
      distribution ''
      components ['']
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
  if node['r-language']['enable_repo'] && ['rhel', 'amazon'].include?(platform_family)
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