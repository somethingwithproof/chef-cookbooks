#
# Cookbook:: Site
# Recipe:: default
#
# Copyright:: 2016, Thomas Vincent
#
# All rights reserved - Do Not Redistribute
#
execute 'disable-default-site' do
  command 'a2dissite default'
end

web_app 'site' do
  application_name 'site-app'
  docroot '/vagrant/web'
end
