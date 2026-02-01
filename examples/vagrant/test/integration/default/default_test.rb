# InSpec test for vagrant_example::default

describe package('apache2') do
  it { should be_installed }
end

describe service('apache2') do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe directory('/var/www/html') do
  it { should exist }
  its('owner') { should eq 'www-data' }
end

describe file('/etc/apache2/sites-available/default.conf') do
  it { should exist }
  its('content') { should match(%r{DocumentRoot /var/www/html}) }
end
