# SNMP Trapd InSpec Tests

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
trap_service = os.family == 'debian' ? 'snmptrapd' : 'snmpd'
describe service(trap_service) do
  it { should be_enabled }
  it { should be_running }
end

# Configuration files
describe file('/etc/snmp/snmpd.conf') do
  it { should exist }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its('mode') { should cmp '0600' }
end

describe file('/etc/snmp/snmptrapd.conf') do
  it { should exist }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its('content') { should match /public/ }
end

# SNMP trap port
describe port(162) do
  it { should be_listening }
  its('protocols') { should include 'udp' }
end
