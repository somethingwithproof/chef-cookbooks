# InSpec test for recipe tcp_wrappers::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

control 'tcp-wrappers-directory-1.0' do
  impact 0.7
  title 'TCP Wrappers directory is properly configured'
  desc 'Verifies that the wrappers.d directory exists with appropriate permissions'

  describe file('/etc/wrappers.d') do
    it { should exist }
    it { should be_directory }
    its('mode') { should cmp '0755' }
  end
end

control 'tcp-wrappers-sshd-file-1.0' do
  impact 0.7
  title 'TCP Wrappers SSHD file is properly configured'
  desc 'Verifies that the SSHD tcp_wrappers file exists and has proper content'

  # Only run this test if the file exists
  only_if('SSHD file exists') do
    file('/etc/wrappers.d/sshd').exist?
  end

  describe file('/etc/wrappers.d/sshd') do
    it { should be_file }
    its('mode') { should cmp '0440' }
    its('content') { should match(%r{ALLOW}) }
  end
end

control 'tcp-wrappers-hosts-allow-1.0' do
  impact 0.7
  title 'TCP Wrappers hosts.allow file exists'
  desc 'Verifies that hosts.allow exists in the appropriate directory'

  describe file('/etc/hosts.allow') do
    it { should exist }
    it { should be_file }
  end
end

control 'tcp-wrappers-hosts-deny-1.0' do
  impact 0.7
  title 'TCP Wrappers hosts.deny file exists'
  desc 'Verifies that hosts.deny exists in the appropriate directory'

  describe file('/etc/hosts.deny') do
    it { should exist }
    it { should be_file }
  end
end

control 'tcp-wrappers-package-1.0' do
  impact 0.7
  title 'TCP Wrappers package is installed'
  desc 'Verifies that TCP Wrappers package is installed according to platform'

  if os.debian? && os.release.to_f >= 22.04
    describe package('tcpd') do
      it { should be_installed }
    end
  elsif os.linux?
    describe package('tcp_wrappers').or(package('tcpd')) do
      it { should be_installed }
    end
  end
end