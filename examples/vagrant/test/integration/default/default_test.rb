# InSpec test for vagrant_example::default

# Platform-specific settings
case os[:family]
when 'debian'
  package_name = 'apache2'
  service_name = 'apache2'
  apache_user = 'www-data'
  config_file = '/etc/apache2/sites-available/default.conf'
when 'redhat', 'fedora', 'amazon'
  package_name = 'httpd'
  service_name = 'httpd'
  apache_user = 'apache'
  config_file = '/etc/httpd/conf.d/default.conf'
end

describe package(package_name) do
  it { should be_installed }
end

describe service(service_name) do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe directory('/var/www/html') do
  it { should exist }
  its('owner') { should eq apache_user }
end

describe file(config_file) do
  it { should exist }
  its('content') { should match(%r{DocumentRoot /var/www/html}) }
end
