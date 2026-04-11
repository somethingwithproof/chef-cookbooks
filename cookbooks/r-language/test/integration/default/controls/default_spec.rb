# InSpec tests for recipe r-language::default

control 'r-installation' do
  impact 1.0
  title 'R Language Installation'
  desc 'Verify R is properly installed and functional'

  describe command('R --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/R version \d+\.\d+\.\d+/) }
  end

  describe command('which R') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(%r{/usr/(local/)?bin/R}) }
  end

  describe command('Rscript --version') do
    its('exit_status') { should eq 0 }
  end
end

control 'r-functionality' do
  impact 0.7
  title 'R Basic Functionality'
  desc 'Verify R can execute basic commands'

  describe command('Rscript -e "print(1+1)"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/\[1\] 2/) }
  end

  describe command('Rscript -e "sessionInfo()"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/R version/) }
  end
end
