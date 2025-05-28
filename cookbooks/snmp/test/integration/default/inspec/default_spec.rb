# SNMP InSpec Tests

# Package installed
if os.family == 'debian'
  describe package('snmpd') do
    it { should be_installed }
  end
else
  describe package('net-snmp') do
    it { should be_installed }
  end
end

# Service enabled and running
describe service('snmpd') do
  it { should be_enabled }
  it { should be_running }
end

# Configuration files
if os.family == 'debian'
  describe file('/etc/default/snmpd') do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
  end
end

describe file('/etc/snmp/snmpd.conf') do
  it { should exist }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its('mode') { should cmp '0600' }
  its('content') { should match /public/ }
end

# SNMP port
describe port(161) do
  it { should be_listening }
  its('protocols') { should include 'udp' }
end
