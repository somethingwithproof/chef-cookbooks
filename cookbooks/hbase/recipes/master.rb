#
# Cookbook:: hbase
# Recipe:: master
#
# Copyright:: 2023 Thomas Vincent
#
# Licensed under the Apache License, Version 2.0

master_config = node['hbase']['service_mapping']['master']['config'] || {}

hbase_service 'master' do
  restart_on_config_change true
  service_config master_config
  action [:create, :enable, :start]
end
