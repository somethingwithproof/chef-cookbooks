# frozen_string_literal: true

source 'https://rubygems.org'

# Core Chef development tools
gem 'chef', '~> 18.7'
gem 'chef-cli', '~> 5.6'

# Testing frameworks
gem 'chefspec', '~> 9.3'
gem 'inspec', '~> 5.22'
gem 'test-kitchen', '~> 3.7'

# Test Kitchen drivers
gem 'kitchen-dokken', '~> 2.20'      # For CI/CD testing
gem 'kitchen-docker', '~> 3.0'       # For devcontainer testing (default)
gem 'kitchen-inspec', '~> 2.6'

# Code quality and linting
gem 'cookstyle', '~> 7.32'

# Development tools
group :development do
  gem 'rake', '~> 13.0'
  gem 'rb-readline' # Better readline support
end

# Testing utilities
group :test do
  gem 'rspec', '~> 3.12'
  gem 'rspec-its', '~> 1.3'
  gem 'simplecov', '~> 0.22'
  gem 'simplecov-console', '~> 0.9'
end

# Documentation
group :docs do
  gem 'yard', '~> 0.9'
  gem 'redcarpet', '~> 3.5' # Markdown support for YARD
end
