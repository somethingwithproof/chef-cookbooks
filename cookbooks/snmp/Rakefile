#!/usr/bin/env rake

# Load the necessary gems
begin
  require 'chefspec'
  require 'foodcritic'
  require 'rubocop'
  require 'kitchen'
rescue LoadError
  puts '>>>>> One or more required gems are missing, please run `bundle install` to install them.'
end

# chefspec task against spec/*_spec.rb
RSpec::Core::RakeTask.new(:chefspec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

# foodcritic linter task
desc 'Run Foodcritic linter'
task :foodcritic do
  sh 'foodcritic -f correctness .'
end

# rubocop linter task
desc 'Run RuboCop linter'
task :rubocop do
  sh 'rubocop --fail-level W'
end

# test-kitchen task
desc 'Run Test Kitchen'
task :test do
  sh 'kitchen test'
end

# Deploy task
desc 'Deploy to the Chef Server and pin to the environment'
task :deploy do
  sh 'berks upload'
  sh 'berks apply ci'
end

# erubis syntax check task
desc 'Check Erubis syntax'
task :erbcheck do
  sh "erubis -x -T '-' templates/default/*.erb | ruby -c"
end

#
