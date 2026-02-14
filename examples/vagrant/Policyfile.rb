name 'chef-vagrant-example'
default_source :supermarket
run_list 'chef-vagrant-example::default'
cookbook 'chef-vagrant-example', path: '.'
