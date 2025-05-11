property :package_name, String, name_property: true
property :version, String
property :repo, String, default: 'https://cloud.r-project.org'
property :bioc, [true, false], default: false

action :install do
  r_package_script = "#{Chef::Config[:file_cache_path]}/install_#{new_resource.package_name}.R"

  template r_package_script do
    cookbook 'r-language'
    source 'r_package_install.R.erb'
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      package_name: new_resource.package_name,
      version: new_resource.version,
      repo: new_resource.repo,
      bioc: new_resource.bioc
    )
    action :create
  end

  execute "install_r_package_#{new_resource.package_name}" do
    command "/usr/bin/Rscript #{r_package_script}"
    action :run
    not_if { ::File.exist?(r_package_script) && package_installed?(new_resource.package_name, new_resource.version) }
  end
end

action :remove do
  r_package_script = "#{Chef::Config[:file_cache_path]}/remove_#{new_resource.package_name}.R"

  file r_package_script do
    content <<-EOH
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
    command "/usr/bin/Rscript #{r_package_script}"
    action :run
    only_if { package_installed?(new_resource.package_name) }
  end
end

action_class do
  # Check if an R package is installed
  def package_installed?(package_name, version = nil)
    cmd = if version.nil?
            "Rscript -e \"exit(!require('#{package_name}', quietly = TRUE))\""
          else
            "Rscript -e \"exit(!require('#{package_name}', quietly = TRUE) || packageVersion('#{package_name}') != '#{version}')\""
          end

    shell_out(cmd).exitstatus == 0
  end
end