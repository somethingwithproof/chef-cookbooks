# Policyfile.rb - Policyfile for the r-language cookbook
#
# https://docs.chef.io/policyfile/

name 'r-language'

# Where to find external cookbooks
default_source :supermarket

# Include the cookbook locally
cookbook 'r-language', path: '.'

# Dependencies
cookbook 'apt', '~> 8.0'
cookbook 'yum', '~> 8.0'
cookbook 'build-essential', '~> 9.0'

# Run List for when this application is run directly
run_list 'r-language::default'

# Specify default attributes
default['r-language']['install_method'] = 'package'
default['r-language']['install_dev'] = true
default['r-language']['enable_repo'] = true
