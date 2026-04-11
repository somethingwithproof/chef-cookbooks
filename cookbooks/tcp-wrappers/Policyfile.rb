name 'tcp_wrappers'
default_source :supermarket
run_list 'tcp_wrappers::default'
cookbook 'tcp_wrappers', path: '.'
cookbook 'test', path: 'test/fixtures/cookbooks/test'
