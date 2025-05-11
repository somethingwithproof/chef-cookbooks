# InSpec test for recipe r-language::packages and r_package resource

# First check if R is installed
describe command('R --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/R version/) }
end

# Test the installation of some common packages
describe command(%q{R --slave -e 'if(require("dplyr")) cat("dplyr is installed\n") else cat("dplyr is NOT installed\n")'}) do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/dplyr is installed/) }
end

describe command(%q{R --slave -e 'if(require("ggplot2")) cat("ggplot2 is installed\n") else cat("ggplot2 is NOT installed\n")'}) do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/ggplot2 is installed/) }
end

# Check that the packages can be loaded and used
describe command(%q{R --slave -e 'library(dplyr); mtcars %>% filter(cyl == 6) %>% nrow() %>% cat("Number of rows: ", ., "\n")'}) do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/Number of rows: 7/) }
end

describe command(%q{R --slave -e 'library(ggplot2); cat("ggplot2 version: ", packageVersion("ggplot2"), "\n")'}) do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/ggplot2 version: \d+\.\d+\.\d+/) }
end

# Test package repository configuration
describe command(%q{R --slave -e 'cat("Default repos: ", getOption("repos"), "\n")'}) do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/cloud\.r-project\.org/) }
end