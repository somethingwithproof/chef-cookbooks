# frozen_string_literal: true

source 'https://rubygems.org'

# Chef Infra Client 18 ships Ruby 3.1. Pin to match.
ruby '~> 3.1'

group :development do
  gem 'chef',           '~> 18.0'
  gem 'chef-cli',       '~> 5.0'
  gem 'cookstyle',      '~> 8.0'
  gem 'chefspec',       '~> 9.3'
  gem 'berkshelf',      '~> 8.0'
  gem 'knife-spork',    '~> 1.7'
  gem 'rake',           '~> 13.2'
  gem 'rspec',          '~> 3.13'
  gem 'yamllint',       '~> 0.1'
end

group :test do
  gem 'inspec',         '~> 6.0'
  gem 'test-kitchen',   '~> 3.8'
  gem 'kitchen-dokken', '~> 2.22'
  gem 'kitchen-inspec', '~> 3.0'
end
