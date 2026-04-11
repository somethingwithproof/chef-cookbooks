#
# Cookbook:: hbase
# Recipe:: thrift
#
# Copyright:: 2023 Thomas Vincent
#
# Licensed under the Apache License, Version 2.0

thrift_config = node['hbase']['services']['thrift']['config'].to_h

hbase_service 'thrift' do
  restart_on_config_change true
  service_config thrift_config
  action [:create, :enable, :start]
end
