# InSpec test for recipe r-language::package

# Check if R is installed from package
describe package('r-base') do
  it { should be_installed }
end

# Debian-specific tests
if os.debian? || os.ubuntu?
  # Check if the development package is installed
  describe package('r-base-dev') do
    it { should be_installed }
  end

  # Check if the R repository is configured
  describe file('/etc/apt/sources.list.d/r-project.list') do
    it { should exist }
    its('content') { should match(/cloud.r-project.org/) }
  end
end

# RHEL-specific tests
if os.redhat? || os.centos? || os.name == 'amazon'
  # Check if the R package is installed
  describe package('R') do
    it { should be_installed }
  end

  # Check if EPEL repo is configured
  describe file('/etc/yum.repos.d/epel.repo') do
    it { should exist }
  end
end

# Verify R can load some core packages
describe command(%q{R --slave -e 'library(stats); library(graphics); cat("Core packages loaded successfully\n")'}) do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/Core packages loaded successfully/) }
end