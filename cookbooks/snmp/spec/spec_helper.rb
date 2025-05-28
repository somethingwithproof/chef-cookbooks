require 'chefspec'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
end

# Specify platform info for ChefSpec
PLATFORMS = {
  'ubuntu' => { platform: 'ubuntu', version: '22.04', platform_family: 'debian' },
  'centos' => { platform: 'centos', version: '8', platform_family: 'rhel' },
  'debian' => { platform: 'debian', version: '11', platform_family: 'debian' },
}.freeze
