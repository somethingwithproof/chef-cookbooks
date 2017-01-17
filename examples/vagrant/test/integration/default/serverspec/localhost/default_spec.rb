require 'spec_helper'

# Verify packages
describe package('httpd') do
  it { should be_installed }
end

# Verify Gems
describe package('chef') do
  it { should be_installed_by('gem').with_version('12.5.1') }
end

# Verify files
describe file('/vagrant/web/index.html') do
  it { should be_file }
  it { should be_owned_by 'apache' }
  it { should be_grouped_into 'apache' }
  it { should be_mode 755 }
  it { should contain('Automation for the people').before(/^end/) }
end

# Verify services
%w{httpd}.each do |svc|
  describe service(svc) do
    it { should be_running }
  end
end

# Verify ports
%w{80 8080}.each do |ports|
  describe port(ports) do
    it { should be_listening }
  end
end
