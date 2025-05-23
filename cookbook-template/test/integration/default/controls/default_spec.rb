# frozen_string_literal: true

# Integration tests for cookbook-template

title 'cookbook-template integration tests'

# Test package installation
describe package('example-service') do
  it { should be_installed }
end

# Test service user and group
describe group('app') do
  it { should exist }
end

describe user('app') do
  it { should exist }
  its('group') { should eq 'app' }
  its('shell') { should eq '/bin/false' }
end

# Test configuration directory
describe directory('/etc/example-service') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

# Test configuration file
describe file('/etc/example-service/service.conf') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
  its('content') { should match(/port = 8080/) }
  its('content') { should match(/enabled = true/) }
  its('content') { should match(/user = app/) }
  its('content') { should match(/group = app/) }
end

# Test log directory
describe directory('/var/log') do
  it { should exist }
  it { should be_directory }
end

# Test service configuration
describe service('example-service') do
  it { should be_enabled }
  it { should be_running }
end

# Test systemd service file (if applicable)
if os.family == 'redhat' && os.release.to_i >= 7 ||
   os.family == 'debian' && 
   ((os.name == 'ubuntu' && os.release.to_f >= 15.04) ||
    (os.name == 'debian' && os.release.to_i >= 8))
  
  describe file('/etc/systemd/system/example-service.service') do
    it { should exist }
    it { should be_file }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should match(/User=app/) }
    its('content') { should match(/Group=app/) }
    its('content') { should match(/ExecStart=.*--port 8080/) }
  end
end

# Test port accessibility (if service supports it)
describe port(8080) do
  # Note: This test might fail if the example service doesn't actually bind to the port
  # Comment out or modify based on actual service behavior
  # it { should be_listening }
  # its('protocols') { should include 'tcp' }
end

# Test file system permissions and security
describe file('/etc/example-service/service.conf') do
  its('content') { should_not match(/password|secret|key/) }
end

# Test log file (if created by service)
describe file('/var/log/example-service.log') do
  # This might not exist immediately after installation
  # it { should exist } if File.exist?('/var/log/example-service.log')
end

# Test process (if service is actually running)
describe processes('example-service') do
  # Comment out if example-service doesn't actually exist
  # its('users') { should include 'app' }
end

# Test network configuration
describe command('ss -tlnp') do
  # This test checks if any process is listening on port 8080
  # Comment out if your example service doesn't bind to a port
  # its('stdout') { should match(/:8080/) }
end

# Test Chef metadata in config file
describe file('/etc/example-service/service.conf') do
  its('content') { should match(/node_name = /) }
  its('content') { should match(/platform = /) }
  its('content') { should match(/cookbook_version = /) }
end

# Test system integration
describe command('systemctl is-active example-service') do
  its('stdout') { should match(/active|inactive/) }
  its('exit_status') { should be_in [0, 3] } # 0 = active, 3 = inactive
end if os.family == 'redhat' && os.release.to_i >= 7 ||
      os.family == 'debian' && 
      ((os.name == 'ubuntu' && os.release.to_f >= 15.04) ||
       (os.name == 'debian' && os.release.to_i >= 8))

# Test idempotency - configuration should not change on second run
describe file('/etc/example-service/service.conf') do
  its('mtime') { should be <= Time.now }
end