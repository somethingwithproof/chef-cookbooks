# InSpec test for recipe r-language::source

# Check if R is installed in the expected location for source install
describe file('/usr/local/bin/R') do
  it { should exist }
  it { should be_executable }
end

describe file('/usr/local/lib/R') do
  it { should exist }
  it { should be_directory }
end

# Check if R was compiled with shared library support
describe file('/usr/local/lib/R/lib/libR.so') do
  it { should exist }
end

# Check if R from source install works properly
describe command('/usr/local/bin/R --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/R version/) }
end

# Verify Rscript from source install works
describe command('/usr/local/bin/Rscript --version') do
  its('exit_status') { should eq 0 }
  its('stderr') { should match(/R scripting front-end/) }
end

# Test compilation features
describe command(%q{/usr/local/bin/R --slave -e 'cat("R capabilities:\n"); capabilities()'}) do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/jpeg.*TRUE/) }
  its('stdout') { should match(/png.*TRUE/) }
  its('stdout') { should match(/cairo.*TRUE/) }
end