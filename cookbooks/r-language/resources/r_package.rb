unified_mode true
provides :r_package

property :package_name, String, name_property: true, description: 'Name of the R package to install'
property :version, String, description: 'Specific version to install (optional)'
property :repo, String, default: 'https://cloud.r-project.org', description: 'Repository URL to use'
property :bioc, [true, false], default: false, description: 'Whether to use Bioconductor for installation'
property :timeout, Integer, default: 1800, description: 'Timeout for the installation process in seconds'

action :install do
  r_exe = value_for_platform_family(
    %w(debian rhel fedora amazon suse) => '/usr/bin/Rscript',
    'freebsd' => '/usr/local/bin/Rscript',
    'mac_os_x' => '/usr/local/bin/Rscript',
    'windows' => 'Rscript.exe'
  )

  r_package_script = "#{Chef::Config[:file_cache_path]}/install_#{new_resource.package_name}.R"

  r_package_script = win_friendly_path(r_package_script) if platform?('windows')

  template r_package_script do
    cookbook 'r-language'
    source 'r_package_install.R.erb'
    mode '0755'
    owner platform?('windows') ? nil : 'root'
    group platform?('windows') ? nil : 'root'
    variables(
      package_name: new_resource.package_name,
      version: new_resource.version,
      repo: new_resource.repo,
      bioc: new_resource.bioc
    )
    action :create
  end

  execute "install_r_package_#{new_resource.package_name}" do
    command "#{r_exe} #{r_package_script}"
    timeout new_resource.timeout
    action :run
    not_if { package_installed?(new_resource.package_name, new_resource.version, r_exe) }
  end
end

action :remove do
  r_exe = value_for_platform_family(
    %w(debian rhel fedora amazon suse) => '/usr/bin/Rscript',
    'freebsd' => '/usr/local/bin/Rscript',
    'mac_os_x' => '/usr/local/bin/Rscript',
    'windows' => 'Rscript.exe'
  )

  r_package_script = "#{Chef::Config[:file_cache_path]}/remove_#{new_resource.package_name}.R"

  r_package_script = win_friendly_path(r_package_script) if platform?('windows')

  file r_package_script do
    content <<~EOH
      #!/usr/bin/env Rscript
      if(require('#{new_resource.package_name}')) {
        remove.packages('#{new_resource.package_name}')
        if(require('#{new_resource.package_name}')) {
          stop('Failed to remove package: #{new_resource.package_name}')
        }
        print('Successfully removed package: #{new_resource.package_name}')
      } else {
        print('Package already removed: #{new_resource.package_name}')
      }
    EOH
    mode '0755'
    action :create
  end

  execute "remove_r_package_#{new_resource.package_name}" do
    command "#{r_exe} #{r_package_script}"
    timeout new_resource.timeout
    action :run
    only_if { package_installed?(new_resource.package_name, nil, r_exe) }
  end
end

action_class do
  # Check if an R package is installed
  def package_installed?(package_name, version = nil, r_exe = '/usr/bin/Rscript')
    cmd = if version.nil?
            "#{r_exe} -e \"exit(!require('#{package_name}', quietly = TRUE))\""
          else
            "#{r_exe} -e \"exit(!require('#{package_name}', quietly = TRUE) || packageVersion('#{package_name}') != '#{version}')\""
          end

    shell_out(cmd).exitstatus.zero?
  end

  # For Windows compatibility
  def win_friendly_path(path)
    path&.gsub(File::SEPARATOR, File::ALT_SEPARATOR || '\\')
  end
end
