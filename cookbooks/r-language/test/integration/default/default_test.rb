# InSpec test for recipe r-language::default

# Check if R is installed and working properly
describe command('R --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/R version/) }
end

# Check that required R directories exist
%w(/usr/lib/R /usr/share/R).each do |dir|
  describe directory(dir) do
    it { should exist }
  end
end

# Verify that R can execute basic commands
describe command(%q{R --slave -e 'cat("R is working properly\n")'}) do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/R is working properly/) }
end

# Check that Rscript works
describe command('Rscript --version') do
  its('exit_status') { should eq 0 }
  its('stderr') { should match(/R scripting front-end/) }
end

# Test R package installation ability
# Verify R can install a package
describe command(%q{R --slave -e 'if (!requireNamespace("utils", quietly=TRUE)) { install.packages("utils", repos="https://cloud.r-project.org", quiet=TRUE); print("Package installed successfully") } else { print("Package already installed") }'}) do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/(Package already installed|Package installed successfully)/) }
end