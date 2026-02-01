# frozen_string_literal: true

require 'chefspec'
# Use ChefSpec without Berkshelf or Policyfile resolver

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
end

ChefSpec::Coverage.start!
