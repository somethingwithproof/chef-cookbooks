cookbook_path File.expand_path('../', __FILE__)
log_level :info
Chef::Log.level(:info)
ssl_verify_mode :verify_none