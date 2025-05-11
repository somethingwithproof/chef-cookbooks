#
# Cookbook:: r-language
# Recipe:: default
#
# Copyright:: 2025, Thomas Vincent
#
# Installs and configures R programming language

case node['r-language']['install_method']
when 'package'
  include_recipe 'r-language::package'
when 'source'
  include_recipe 'r-language::source'
else
  Chef::Application.fatal!("Invalid install method specified: #{node['r-language']['install_method']}. Please use 'package' or 'source'.")
end

# Install additional R packages if specified
unless node['r-language']['packages'].empty?
  include_recipe 'r-language::packages'
end