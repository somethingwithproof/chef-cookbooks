# frozen_string_literal: true

require 'chefspec'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
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
end

# Platforms representative of the metadata.rb supports matrix.
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
