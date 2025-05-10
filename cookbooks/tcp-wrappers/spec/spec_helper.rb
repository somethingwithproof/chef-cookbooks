require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '20.04'
  config.color = true
  config.formatter = :documentation
  
  # Set ChefSpec::Runner default attributes
  config.cookbook_path = ['../']
  config.log_level = :error

  # Specify the operating system to mock Ohai data for
  config.platform  = 'ubuntu'
  config.version   = '22.04'
  
  # Be random!
  config.order = 'random'
end