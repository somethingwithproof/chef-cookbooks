require 'chefspec'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'
  add_filter '/.kitchen/'
  add_group 'Libraries', 'libraries'
  add_group 'Resources', 'resources'
  add_group 'Recipes', 'recipes'
  enable_coverage :branch
end

Chef::Config[:chef_license] = 'accept-silent'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '22.04'
  config.log_level = :error

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.color = true
  config.formatter = :documentation

  config.before(:each) do
    stub_command('test -L /opt/hbase/current').and_return(false)
    stub_command('java -version').and_return(true)
  end
end
