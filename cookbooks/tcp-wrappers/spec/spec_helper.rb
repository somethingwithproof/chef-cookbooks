require 'chefspec'
require 'fileutils'

# ChefSpec needs cookbook directories to match cookbook names.
# The repo dir is 'chef-tcp-wrappers' but the cookbook name is 'tcp_wrappers'.
cookbook_root = File.expand_path('..', __dir__)
test_cookbooks = File.join(cookbook_root, 'test', 'cookbooks')
symlink = File.join(test_cookbooks, 'tcp_wrappers')

FileUtils.mkdir_p(test_cookbooks)
unless File.symlink?(symlink) && File.readlink(symlink) == cookbook_root
  FileUtils.rm_f(symlink)
  File.symlink(cookbook_root, symlink)
end

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
  config.platform = 'ubuntu'
  config.version = '22.04'
  config.order = 'random'
  config.cookbook_path = [test_cookbooks]
end
