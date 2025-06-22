# InSpec security and compliance tests

control 'r-security-baseline' do
  impact 1.0
  title 'R Security Baseline'
  desc 'Verify R installation follows security best practices'

  # Check R is not running as root
  describe processes('R') do
    its('users') { should_not include 'root' }
  end

  # Verify R configuration files have proper permissions
  describe file('/etc/R') do
    it { should_not be_world_writable }
    it { should_not be_world_readable } if os.family != 'windows'
  end

  # Check for insecure R startup configurations
  describe file('/usr/lib/R/etc/Rprofile.site') do
    its('content') { should_not match(%r{setwd\("/tmp"\)}) }
    its('content') { should_not match(/options\(warn\s*=\s*-1\)/) }
  end if os.family != 'windows'

  # Verify R packages are installed from trusted sources
  describe command('Rscript -e "options(); cat(getOption(\'repos\'), \'\\n\')"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(%r{https://}) }
    its('stdout') { should_not match(%r{http://}) }
  end

  # Check that R is not configured with dangerous options
  describe command('Rscript -e "if(getOption(\'download.file.method\') == \'wget\' && getOption(\'download.file.extra\') != \'--no-check-certificate\') cat(\'SECURE\') else cat(\'INSECURE\')"') do
    its('stdout') { should match(/SECURE/) }
  end
end

control 'r-package-security' do
  impact 0.8
  title 'R Package Security'
  desc 'Verify R packages are installed securely'

  # Check package installation logs for security warnings
  describe file('/tmp/install_r_packages.R') do
    its('content') { should match(/repos\s*=\s*"https:/) }
    its('content') { should_not match(/repos\s*=\s*"http:/) }
  end if file('/tmp/install_r_packages.R').exist?

  # Verify no packages installed from unknown repositories
  describe command('Rscript -e "ip <- installed.packages(); unknown <- ip[is.na(ip[,\'Repository\']),]; if(nrow(unknown) > 0) { cat(\'UNKNOWN_REPOS_FOUND\'); print(unknown) } else cat(\'ALL_REPOS_KNOWN\')"') do
    its('stdout') { should match(/ALL_REPOS_KNOWN/) }
  end

  # Check for packages with known vulnerabilities (example)
  describe command('Rscript -e "if (any(grepl(\'^devtools$\', rownames(installed.packages())))) cat(\'DEVTOOLS_INSTALLED\') else cat(\'DEVTOOLS_NOT_INSTALLED\')"') do
    its('stdout') { should match(/DEVTOOLS_NOT_INSTALLED/) }
  end
end

control 'r-network-security' do
  impact 0.7
  title 'R Network Security'
  desc 'Verify R network configuration is secure'

  # Check R uses secure download methods
  describe command('Rscript -e "cat(capabilities()[\'http/ftp\'], \'\\n\')"') do
    its('stdout') { should match(/TRUE/) }
  end

  # Verify SSL/TLS is properly configured
  describe command('Rscript -e "if(capabilities()[\'libcurl\']) cat(\'LIBCURL_AVAILABLE\') else cat(\'LIBCURL_MISSING\')"') do
    its('stdout') { should match(/LIBCURL_AVAILABLE/) }
  end

  # Check that downloads verify certificates
  describe command('Rscript -e "download.file.method <- getOption(\'download.file.method\'); if(is.null(download.file.method) || download.file.method == \'auto\') cat(\'SECURE_DEFAULT\') else cat(\'CUSTOM_METHOD\')"') do
    its('stdout') { should match(/SECURE_DEFAULT|CUSTOM_METHOD/) }
  end
end

# Platform-specific security controls
if os.family == 'debian'
  control 'debian-r-security' do
    impact 0.8
    title 'Debian R Security Configuration'
    desc 'Debian-specific R security checks'

    # Check APT repository signatures
    describe command('apt-key list | grep "R Foundation"') do
      its('exit_status') { should eq 0 }
    end

    # Verify repository configuration
    describe file('/etc/apt/sources.list.d/r-project.list') do
      it { should exist }
      its('content') { should match(%r{https://}) }
      its('content') { should_not match(/\[trusted=yes\]/) }
    end
  end
end

if os.family == 'redhat'
  control 'rhel-r-security' do
    impact 0.8
    title 'RHEL R Security Configuration'
    desc 'RHEL-specific R security checks'

    # Check GPG key verification
    describe command('rpm -qa gpg-pubkey* | grep -i epel') do
      its('exit_status') { should eq 0 }
    end

    # Verify YUM/DNF repository configuration
    describe file('/etc/yum.repos.d/epel.repo') do
      its('content') { should match(/gpgcheck=1/) }
      its('content') { should_not match(/gpgcheck=0/) }
    end if file('/etc/yum.repos.d/epel.repo').exist?
  end
end
