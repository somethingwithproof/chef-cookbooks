# Policyfile.rb - Policyfile for the r-language cookbook
#
# https://docs.chef.io/policyfile/

name 'r-language'

# Where to find external cookbooks
default_source :supermarket

# Include the cookbook locally
cookbook 'r-language', path: '.'

# No external cookbook dependencies needed
# Chef 18+ includes built-in package management resources

# Run List for when this application is run directly
run_list 'r-language::default'

# Specify default attributes
default['r-language']['install_method'] = 'package'
default['r-language']['install_dev'] = true
default['r-language']['enable_repo'] = true
