#
# Cookbook:: hbase
# Recipe:: regionserver
#
# Copyright:: 2023 Thomas Vincent
#
# Licensed under the Apache License, Version 2.0

regionserver_config = node['hbase']['service_mapping']['regionserver']['config'] || {}

hbase_service 'regionserver' do
  restart_on_config_change true
  service_config regionserver_config
  action [:create, :enable, :start]
end
