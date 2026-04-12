#
# Cookbook:: hbase
# Recipe:: default
#
# Copyright:: 2023 Thomas Vincent
#
# Licensed under the Apache License, Version 2.0

# Kerberos coprocessor/principal properties must be merged before hbase::config
# renders hbase-site.xml, so this block runs ahead of include_recipe 'hbase::config'.
if node['hbase']['security']['authentication'] == 'kerberos'
  krb = node['hbase']['security']['kerberos']
  node.default['hbase']['config'].merge!(
    'hbase.security.authentication' => 'kerberos',
    'hbase.security.authorization' => node['hbase']['security']['authorization'],
    'hbase.master.kerberos.principal' => krb['server_principal'],
    'hbase.regionserver.kerberos.principal' => krb['regionserver_principal'],
    'hbase.master.keytab.file' => krb['keytab'],
    'hbase.regionserver.keytab.file' => krb['keytab'],
    'hbase.rpc.protection' => 'privacy',
    'hbase.coprocessor.master.classes' => 'org.apache.hadoop.hbase.security.access.AccessController',
    'hbase.coprocessor.region.classes' => 'org.apache.hadoop.hbase.security.token.TokenProvider,org.apache.hadoop.hbase.security.access.AccessController'
  )
end

include_recipe 'hbase::java'
include_recipe 'hbase::user'
include_recipe 'hbase::install'
include_recipe 'hbase::config'

if node['hbase']['security']['authentication'] == 'kerberos'
  file node['hbase']['security']['kerberos']['keytab'] do
    owner node['hbase']['user']
    group node['hbase']['group']
    mode '0400'
    action :create
    only_if { ::File.exist?(node['hbase']['security']['kerberos']['keytab']) }
  end
end

case node['hbase']['topology']['role']
when 'master'
  include_recipe 'hbase::master'
when 'regionserver'
  include_recipe 'hbase::regionserver'
when 'backup_master'
  include_recipe 'hbase::backup_master'
else
  master_config = node['hbase']['service_mapping']['master']['config'] || {}
  hbase_service 'master' do
    restart_on_config_change true
    service_config master_config
    action [:create, :enable, :start]
  end
end

include_recipe 'hbase::thrift' if node['hbase']['services']['thrift']['enabled']
include_recipe 'hbase::rest'   if node['hbase']['services']['rest']['enabled']
