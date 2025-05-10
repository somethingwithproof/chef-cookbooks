# InSpec test for recipe tcp_wrappers::remove

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

control 'tcp-wrappers-directory-1.0' do
  impact 0.7
  title 'TCP Wrappers directory exists'
  desc 'Verifies that the wrappers.d directory exists'

  describe file('/etc/wrappers.d') do
    it { should exist }
    it { should be_directory }
  end
end

control 'tcp-wrappers-sshd-file-1.0' do
  impact 0.7
  title 'TCP Wrappers SSHD file exists'
  desc 'Verifies that the SSHD tcp_wrappers file still exists'

  describe file('/etc/wrappers.d/sshd') do
    it { should exist }
    it { should be_file }
  end
end

control 'tcp-wrappers-all-services-file-1.0' do
  impact 0.7
  title 'TCP Wrappers ALL Services file exists'
  desc 'Verifies that the ALL Services tcp_wrappers file still exists'

  describe file('/etc/wrappers.d/all_services') do
    it { should exist }
    it { should be_file }
  end
end

control 'tcp-wrappers-ftpd-file-removed-1.0' do
  impact 0.7
  title 'TCP Wrappers FTPD file has been removed'
  desc 'Verifies that the FTPD tcp_wrappers file has been removed'

  describe file('/etc/wrappers.d/ftpd') do
    it { should_not exist }
  end
end

control 'tcp-wrappers-package-1.0' do
  impact 0.7
  title 'TCP Wrappers package is still installed'
  desc 'Verifies that TCP Wrappers package is still installed'

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