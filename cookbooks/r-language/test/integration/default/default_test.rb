# InSpec test for recipe r-language::default

# Determine the platform-specific install locations
r_dirs = case os.family
         when 'debian', 'ubuntu'
           %w(/usr/lib/R /usr/share/R)
         when 'redhat', 'amazon', 'fedora', 'rocky'
           %w(/usr/lib64/R /usr/share/R)
         when 'suse'
           %w(/usr/lib64/R /usr/share/R)
         when 'freebsd'
           %w(/usr/local/lib/R /usr/local/share/R)
         when 'darwin'
           %w(/usr/local/lib/R /usr/local/share/R)
         when 'windows'
           ['C:/Program Files/R']
         else
           %w(/usr/lib/R /usr/share/R)
         end

# Get R executable path based on OS
r_executable = case os.family
               when 'windows'
                 'R.exe'
               when 'freebsd', 'darwin'
                 '/usr/local/bin/R'
               else
                 'R'
               end

# Get Rscript executable path based on OS
rscript_executable = case os.family
                     when 'windows'
                       'Rscript.exe'
                     when 'freebsd', 'darwin'
                       '/usr/local/bin/Rscript'
                     else
                       'Rscript'
                     end

# Check if R is installed and working properly
describe command("#{r_executable} --version") do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/R version/) }
end

# Check that required R directories exist
unless os.windows?
  r_dirs.each do |dir|
    describe directory(dir) do
      it { should exist }
    end
  end
end

# Verify that R can execute basic commands
r_command = %q{cat("R is working properly\n")}
r_test_cmd = if os.windows?
               "\"#{r_executable}\" --slave -e \"#{r_command}\""
             else
               "#{r_executable} --slave -e '#{r_command}'"
             end

describe command(r_test_cmd) do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/R is working properly/) }
end

# Check that Rscript works
describe command("#{rscript_executable} --version") do
  its('exit_status') { should eq 0 }
  its('stderr') { should match(/R scripting front-end/) } unless os.windows? # Windows outputs to stdout, not stderr
  its('stdout') { should match(/R scripting front-end/) } if os.windows?
end

# Test R package installation ability
# Verify R can install a package
r_pkg_test = 'if (!requireNamespace("utils", quietly=TRUE)) { install.packages("utils", repos="https://cloud.r-project.org", quiet=TRUE); print("Package installed successfully") } else { print("Package already installed") }'
r_pkg_cmd = if os.windows?
              "\"#{r_executable}\" --slave -e \"#{r_pkg_test}\""
            else
              "#{r_executable} --slave -e '#{r_pkg_test}'"
            end

describe command(r_pkg_cmd) do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/(Package already installed|Package installed successfully)/) }
end
