# frozen_string_literal: true

require 'cookstyle'
require 'rspec/core/rake_task'
require 'kitchen/rake_tasks'

# Style and linting
desc 'Run all style checks'
task style: %w(style:cookstyle)

namespace :style do
  desc 'Run Cookstyle linter'
  task :cookstyle do
    sh 'bundle exec cookstyle'
  end
end

# Unit tests
desc 'Run ChefSpec unit tests'
RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = 'spec/unit/**/*_spec.rb'
  task.rspec_opts = '--color --format documentation'
end

# Integration tests
desc 'Run Test Kitchen integration tests'
task :integration do
  Kitchen.logger = Kitchen.default_file_logger
  Kitchen::Config.new.instances.each do |instance|
    instance.test(:always)
  end
end

# All tests
desc 'Run all tests'
task test: %w(style spec)

# Default task
task default: %w(test)

# Cleanup
desc 'Cleanup test artifacts'
task :clean do
  %w(.kitchen logs).each do |dir|
    rm_rf dir if Dir.exist?(dir)
  end
end