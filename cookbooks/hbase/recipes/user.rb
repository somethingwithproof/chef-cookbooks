#
# Cookbook:: hbase
# Recipe:: user
#
# Copyright:: 2023 Thomas Vincent
#
# Licensed under the Apache License, Version 2.0

group node['hbase']['group'] do
  gid node['hbase']['gid']
  system true
  action :create
end

user node['hbase']['user'] do
  comment 'HBase Service Account'
  uid node['hbase']['uid']
  gid node['hbase']['group']
  home node['hbase']['install_dir']
  shell '/bin/bash'
  system true
  action :create
end

# PAM limits live in hbase::limits so they can be composed independently.
include_recipe 'hbase::limits'
