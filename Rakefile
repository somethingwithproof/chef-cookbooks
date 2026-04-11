# frozen_string_literal: true

require 'rake'

COOKBOOKS = Dir['cookbooks/*'].select { |d| File.directory?(d) }.map { |d| File.basename(d) }

namespace :cookbook do
  COOKBOOKS.each do |cb|
    namespace cb.to_sym do
      desc "cookstyle lint for #{cb}"
      task :lint do
        sh "cookstyle cookbooks/#{cb}"
      end

      desc "ChefSpec unit tests for #{cb}"
      task :spec do
        Dir.chdir("cookbooks/#{cb}") do
          sh 'bundle exec rspec spec/'
        end
      end

      desc "test-kitchen converge for #{cb}"
      task :kitchen do
        Dir.chdir("cookbooks/#{cb}") do
          sh 'bundle exec kitchen test'
        end
      end
    end
  end
end

desc 'cookstyle lint across all cookbooks'
task :lint do
  sh 'cookstyle cookbooks/'
end

desc 'ChefSpec unit tests across all cookbooks'
task :spec do
  COOKBOOKS.each do |cb|
    next unless File.directory?("cookbooks/#{cb}/spec")
    Rake::Task["cookbook:#{cb}:spec"].invoke
  end
end

desc 'test-kitchen across all cookbooks (slow)'
task :kitchen do
  COOKBOOKS.each do |cb|
    next unless File.exist?("cookbooks/#{cb}/kitchen.yml")
    Rake::Task["cookbook:#{cb}:kitchen"].invoke
  end
end

task default: %i[lint spec]
