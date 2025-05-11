module RLanguage
  module Helpers
    # Determine the appropriate repository for the platform
    def r_repository_url
      case node['platform']
      when 'ubuntu'
        codename = node['lsb']['codename']
        "#{node['r-language']['ubuntu']['repo']} #{codename}-cran40/"
      when 'debian' 
        codename = node['lsb']['codename']
        "#{node['r-language']['debian']['repo']} #{codename}-cran40/"
      when 'centos', 'redhat', 'amazon'
        node['r-language']['rhel']['repo_url'].gsub('#{node["platform_version"].to_i}', node['platform_version'].to_i.to_s)
      else
        Chef::Log.warn("Unsupported platform for R repository: #{node['platform']}")
        nil
      end
    end

    # Determine the appropriate repository key for the platform
    def r_repository_key
      case node['platform']
      when 'ubuntu'
        node['r-language']['ubuntu']['key']
      when 'debian'
        node['r-language']['debian']['key']
      when 'centos', 'redhat', 'amazon'
        node['r-language']['rhel']['key_url'].gsub('#{node["platform_version"].to_i}', node['platform_version'].to_i.to_s)
      else
        Chef::Log.warn("Unsupported platform for R repository key: #{node['platform']}")
        nil
      end
    end

    # Check if R is installed
    def r_installed?
      if node['r-language']['install_method'] == 'source'
        ::File.exist?('/usr/local/bin/R')
      else
        case node['platform_family']
        when 'debian'
          shell_out('dpkg-query -W -f=\'${Status}\' r-base 2>/dev/null | grep -q "^install ok installed"')
          $?.success?
        when 'rhel', 'fedora', 'amazon'
          shell_out('rpm -q R')
          $?.success?
        else
          false
        end
      end
    end

    # Get the installed R version
    def r_version
      r_exec = node['r-language']['install_method'] == 'source' ? '/usr/local/bin/R' : 'R'
      cmd = shell_out("#{r_exec} --version | head -n 1 | grep -o '[0-9]\\+\\.[0-9]\\+\\.[0-9]\\+'")
      cmd.stdout.strip
    end
  end
end

Chef::Recipe.include(RLanguage::Helpers)
Chef::Resource.include(RLanguage::Helpers)