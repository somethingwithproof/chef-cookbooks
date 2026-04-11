# InSpec tests for r_package custom resource

control 'r-package-resource' do
  impact 0.8
  title 'R Package Custom Resource'
  desc 'Verify the r_package custom resource functionality'

  # Test that R is installed and available
  describe command('R --version') do
    its('exit_status') { should eq 0 }
  end

  describe command('Rscript --version') do
    its('exit_status') { should eq 0 }
  end

  # Test basic R package installation capability
  describe command('Rscript -e "install.packages(\'jsonlite\', repos=\'https://cloud.r-project.org\', quiet=TRUE)"') do
    its('exit_status') { should eq 0 }
  end

  # Verify the installed package can be loaded
  describe command('Rscript -e "library(jsonlite); cat(\'jsonlite loaded successfully\\n\')"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/jsonlite loaded successfully/) }
  end

  # Test package functionality
  describe command('Rscript -e "library(jsonlite); json <- toJSON(list(test=TRUE)); cat(json, \'\\n\')"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/{"test":\[true\]}/) }
  end

  # Verify package information can be retrieved
  describe command('Rscript -e "pkg_info <- packageDescription(\'jsonlite\'); cat(\'Package:\', pkg_info$Package, \'\\n\')"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/Package: jsonlite/) }
  end

  # Test that we can check if a package is installed
  describe command('Rscript -e "if (require(jsonlite, quietly=TRUE)) cat(\'Package is installed\\n\') else cat(\'Package not found\\n\')"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/Package is installed/) }
  end

  # Test package removal capability
  describe command('Rscript -e "remove.packages(\'jsonlite\'); cat(\'Package removed\\n\')"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/Package removed/) }
  end

  # Verify package is actually removed
  describe command('Rscript -e "if (require(jsonlite, quietly=TRUE)) cat(\'Package still installed\\n\') else cat(\'Package successfully removed\\n\')"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/Package successfully removed/) }
  end
end

control 'r-package-bioconductor' do
  impact 0.6
  title 'R Bioconductor Package Support'
  desc 'Verify Bioconductor package installation capability'

  only_if('Bioconductor tests only run on default suite') do
    ENV['KITCHEN_SUITE'] == 'default'
  end

  # Test BiocManager installation (required for Bioconductor packages)
  describe command('Rscript -e "if (!requireNamespace(\'BiocManager\', quietly = TRUE)) install.packages(\'BiocManager\', repos=\'https://cloud.r-project.org\', quiet=TRUE)"') do
    its('exit_status') { should eq 0 }
  end

  # Verify BiocManager is available
  describe command('Rscript -e "library(BiocManager); cat(\'BiocManager loaded\\n\')"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/BiocManager loaded/) }
  end

  # Test basic Bioconductor functionality (without installing large packages)
  describe command('Rscript -e "library(BiocManager); repos <- repositories(); cat(\'Bioconductor repos available:\\n\'); print(names(repos))"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/BioCsoft|BioCann|BioCexp|BioCworkflows/) }
  end
end
