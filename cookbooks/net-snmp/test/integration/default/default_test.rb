# InSpec test for recipe net-snmp::default

# The package should be installed
describe package('snmp') do
  it { should be_installed }
end

# The service should be running and enabled
describe service('snmpd') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# Port 161 should be listening
describe port(161) do
  it { should be_listening }
  its('protocols') { should include 'udp' }
end
