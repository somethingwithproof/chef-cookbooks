# InSpec test for recipe r-language::packages

# Verify R is installed
describe command('R --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/R version/) }
end

# Check if test packages are installed
# These should match the packages specified in kitchen.yml for the packages suite
describe command('Rscript -e "if (!require(dplyr, quietly = TRUE)) quit(status = 1); cat(\'dplyr loaded successfully\\n\')"') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/dplyr loaded successfully/) }
end

describe command('Rscript -e "if (!require(ggplot2, quietly = TRUE)) quit(status = 1); cat(\'ggplot2 loaded successfully\\n\')"') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/ggplot2 loaded successfully/) }
end

# Test that packages can be used for basic operations
describe command('Rscript -e "library(dplyr); data(mtcars); result <- mtcars %>% filter(mpg > 20); cat(nrow(result), \'\\n\')"') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/\d+/) }
end

describe command('Rscript -e "library(ggplot2); p <- ggplot(mtcars, aes(x=mpg, y=hp)) + geom_point(); cat(\'Plot created successfully\\n\')"') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/Plot created successfully/) }
end

# Verify package installation script was created
describe file('/tmp/install_r_packages.R') do
  it { should exist }
  its('content') { should match(/install.packages/) }
  its('content') { should match(/dplyr/) }
  its('content') { should match(/ggplot2/) }
end

# Test that CRAN mirror is accessible
describe command('Rscript -e "options(timeout = 60); available <- available.packages(); cat(\'CRAN mirror accessible, packages:\', nrow(available), \'\\n\')"') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/CRAN mirror accessible/) }
end

# Verify package dependencies are properly resolved
describe command('Rscript -e "pkg_info <- packageDescription(\'dplyr\'); cat(\'Package:\', pkg_info$Package, \'Version:\', pkg_info$Version, \'\\n\')"') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/Package: dplyr Version:/) }
end
