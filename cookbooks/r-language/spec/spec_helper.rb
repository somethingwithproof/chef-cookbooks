require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  # Specify the Chef log level (default: :warn)
  config.log_level = :error

  # Specify the operating platform to mock Ohai data from
  config.platform = 'ubuntu'

  # Specify the operating version to mock Ohai data from
  config.version = '20.04'
end