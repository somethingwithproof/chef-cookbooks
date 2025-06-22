require 'chefspec'

# Enable coverage reporting when COVERAGE env var is set
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/test/'
    add_filter '/vendor/'

    add_group 'Recipes', 'recipes'
    add_group 'Resources', 'resources'
    add_group 'Libraries', 'libraries'
    add_group 'Attributes', 'attributes'

    minimum_coverage 80
    minimum_coverage_by_file 70
  end
end

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
end

# Stub commands used in recipes
def stub_commands
  stub_command('/usr/bin/test -x /usr/local/bin/R').and_return(false)
  stub_command('which R').and_return(false)
end

# Stub shell_out for r_package resource
def stub_r_package_shell_out(package_name, installed = false, version = nil)
  stubs_for_provider("r_package[#{package_name}]") do |provider|
    allow(provider).to receive(:shell_out).with("/usr/bin/Rscript -e \"exit(!require('#{package_name}', quietly = TRUE))\"").and_return(
      double(exitstatus: installed ? 0 : 1)
    )
    if version
      allow(provider).to receive(:shell_out).with("/usr/bin/Rscript -e \"exit(!require('#{package_name}', quietly = TRUE) || packageVersion('#{package_name}') != '#{version}')\"").and_return(
        double(exitstatus: installed ? 0 : 1)
      )
    end
  end
end
