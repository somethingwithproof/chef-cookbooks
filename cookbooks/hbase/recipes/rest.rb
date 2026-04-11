#
# Cookbook:: hbase
# Recipe:: rest
#
# Copyright:: 2023 Thomas Vincent
#
# Licensed under the Apache License, Version 2.0

rest_config = node['hbase']['services']['rest']['config'].to_h

hbase_service 'rest' do
  restart_on_config_change true
  service_config rest_config
  action [:create, :enable, :start]
end
