#
# Cookbook:: hbase
# Recipe:: backup_master
#
# Copyright:: 2023 Thomas Vincent
#
# Licensed under the Apache License, Version 2.0

# A backup master is an ordinary master daemon; the node simply gets listed
# in the backup-masters file that the active master reads at startup.
master_config = node['hbase']['service_mapping']['master']['config'] || {}

hbase_service 'master' do
  restart_on_config_change true
  service_config master_config
  action [:create, :enable, :start]
end
