# frozen_string_literal: true

# Policyfile.rb - Describes and locks the cookbook dependency graph

# A name that describes what the system you're building with Chef does.
name 'cookbook-template'

# Where to find external cookbooks:
default_source :supermarket

# Run list for this policy
run_list 'cookbook-template::default'

# Specify a custom source for a cookbook:
cookbook 'cookbook-template', path: '.'

# Named run lists for different environments/roles
named_run_list :integration, 'cookbook-template::default'
named_run_list :unit_test, 'cookbook-template::default'

# Attributes for testing
default['cookbook_template']['service']['port'] = 8080
default['cookbook_template']['service']['enabled'] = true