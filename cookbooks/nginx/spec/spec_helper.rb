# frozen_string_literal: true

require 'chefspec'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'
  add_filter '/.kitchen/'
  add_filter '/test/'
  add_group 'Libraries', 'libraries'
  add_group 'Resources', 'resources'
  add_group 'Recipes', 'recipes'
end

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
  config.platform = 'ubuntu'
  config.version = '22.04'

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

# Matches the metadata.rb supports matrix.
SUPPORTED_PLATFORMS = [
  { platform: 'ubuntu',    version: '20.04' },
  { platform: 'ubuntu',    version: '22.04' },
  { platform: 'ubuntu',    version: '24.04' },
  { platform: 'debian',    version: '11' },
  { platform: 'debian',    version: '12' },
  { platform: 'rocky',     version: '8' },
  { platform: 'rocky',     version: '9' },
  { platform: 'almalinux', version: '8' },
  { platform: 'almalinux', version: '9' },
  { platform: 'amazon',    version: '2023' },
].freeze

# Common stubs required by nginx recipes.
def stub_nginx_commands
  stub_command('dpkg -l nginx-core 2>/dev/null | grep -q ^ii || dpkg -l nginx-light 2>/dev/null | grep -q ^ii').and_return(false)
  stub_command('test -f /etc/apt/sources.list.d/nginx.list').and_return(false)
end
