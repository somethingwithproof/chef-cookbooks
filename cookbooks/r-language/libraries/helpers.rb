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
      when 'centos', 'redhat', 'amazon', 'rocky', 'oracle'
        node['r-language']['rhel']['repo_url'].gsub(node['platform_version'].to_i.to_s,
                                                    node['platform_version'].to_i.to_s)
      when 'suse', 'opensuse'
        'https://cloud.r-project.org/bin/linux/suse/'
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
      when 'centos', 'redhat', 'amazon', 'rocky', 'oracle'
        node['r-language']['rhel']['key_url'].gsub(node['platform_version'].to_i.to_s,
                                                   node['platform_version'].to_i.to_s)
      else
        Chef::Log.warn("Unsupported platform for R repository key: #{node['platform']}")
        nil
      end
    end

    # Get the R executable path based on platform and installation method
    def r_executable
      return '/usr/local/bin/R' if node['r-language']['install_method'] == 'source'

      value_for_platform_family(
        'debian' => '/usr/bin/R',
        %w(rhel fedora amazon) => '/usr/bin/R',
        'suse' => '/usr/bin/R',
        'freebsd' => '/usr/local/bin/R',
        'mac_os_x' => '/usr/local/bin/R',
        'windows' => 'R.exe',
        'default' => '/usr/bin/R'
      )
    end

    # Get the Rscript executable path based on platform
    def rscript_executable
      value_for_platform_family(
        'debian' => '/usr/bin/Rscript',
        %w(rhel fedora amazon) => '/usr/bin/Rscript',
        'suse' => '/usr/bin/Rscript',
        'freebsd' => '/usr/local/bin/Rscript',
        'mac_os_x' => '/usr/local/bin/Rscript',
        'windows' => 'Rscript.exe',
        'default' => '/usr/bin/Rscript'
      )
    end

    # Check if R is installed. Uses array-form shell_out where possible; the
    # debian dpkg-query path still needs a shell pipeline so we keep that one
    # as a string but mark it explicitly.
    def r_installed?
      if node['r-language']['install_method'] == 'source'
        ::File.exist?('/usr/local/bin/R')
      else
        case node['platform_family']
        when 'debian'
          status = shell_out('dpkg-query', '-W', '-f=${Status}', 'r-base').stdout.to_s
          status.include?('install ok installed')
        when 'rhel', 'fedora', 'amazon'
          shell_out('rpm', '-q', 'R').exitstatus.zero?
        when 'suse'
          shell_out('rpm', '-q', 'R-base').exitstatus.zero?
        when 'freebsd'
          shell_out('pkg', 'info', '-e', 'R').exitstatus.zero?
        when 'mac_os_x'
          shell_out('brew', 'list', '--formula', 'r').exitstatus.zero? || ::File.exist?('/usr/local/bin/R')
        when 'windows'
          ::File.exist?('C:/Program Files/R') || ::File.exist?('C:/Program Files (x86)/R')
        else
          false
        end
      end
    end

    # Get the installed R version using array-form shell_out and a Ruby
    # regex match instead of a head/grep pipeline.
    def r_version
      r_exec = r_executable
      cmd = shell_out(r_exec, '--version')
      m = cmd.stdout.match(/(\d+\.\d+\.\d+)/)
      m ? m[1] : ''
    end

    # Get R package installation prefix based on platform
    def r_package_prefix
      if node['r-language']['install_method'] == 'source'
        '/usr/local/lib/R/site-library'
      else
        case node['platform_family']
        when 'debian'
          '/usr/lib/R/site-library'
        when 'rhel', 'fedora', 'amazon', 'suse'
          '/usr/lib64/R/library'
        when 'freebsd'
          '/usr/local/lib/R/library'
        when 'mac_os_x'
          '/usr/local/lib/R/library'
        when 'windows'
          'C:/Program Files/R/library'
        else
          '/usr/lib/R/library'
        end
      end
    end
  end
end

Chef::DSL::Recipe.include(RLanguage::Helpers)
Chef::DSL::Universal.include(RLanguage::Helpers)
