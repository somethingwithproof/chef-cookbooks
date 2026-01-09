# frozen_string_literal: true

# InSpec test for SNMPv3 configuration

describe package('snmpd') do
  it { should be_installed }
end

describe service('snmpd') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/snmp/snmpd.conf') do
  it { should exist }
  its('mode') { should cmp '0600' }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
end

describe port(161) do
  it { should be_listening }
  its('protocols') { should include 'udp' }
end

# Verify SNMPv3 user exists in persistent storage
describe file('/var/lib/snmp/snmpd.conf') do
  it { should exist }
  its('content') { should match(/usmUser/) }
end
