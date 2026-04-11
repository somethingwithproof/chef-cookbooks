require 'spec_helper'

describe 'vagrant_example::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04').converge(described_recipe)
  end

  it 'converges successfully' do
    expect { chef_run }.not_to raise_error
  end

  it 'updates apt cache' do
    expect(chef_run).to periodic_apt_update('update')
  end

  it 'installs apache2 package' do
    expect(chef_run).to install_package('apache2')
  end

  it 'enables and starts apache2 service' do
    expect(chef_run).to enable_service('apache2')
    expect(chef_run).to start_service('apache2')
  end

  it 'creates the document root directory' do
    expect(chef_run).to create_directory('/var/www/html')
  end

  it 'creates the default vhost' do
    expect(chef_run).to create_apache_vhost('default')
  end

  it 'logs completion message' do
    expect(chef_run).to write_log('vagrant_example')
  end
end
