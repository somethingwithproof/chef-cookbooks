# frozen_string_literal: true

require 'spec_helper'

describe 'nginx::letsencrypt' do
  before { stub_nginx_commands }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
      node.normal['nginx']['letsencrypt']['enabled'] = true
      node.normal['nginx']['letsencrypt']['email'] = 'ops@example.com'
    end.converge(described_recipe)
  end

  it 'installs certbot and the nginx plugin' do
    expect(chef_run).to install_package(%w(certbot python3-certbot-nginx))
  end

  it 'creates the webroot directory' do
    expect(chef_run).to create_directory('/var/www/letsencrypt').with(mode: '0755')
  end

  it 'creates the acme challenge directory' do
    expect(chef_run).to create_directory('/var/www/letsencrypt/.well-known/acme-challenge').with(mode: '0755')
  end

  it 'renders the letsencrypt include' do
    expect(chef_run).to create_template('/etc/nginx/conf.d/letsencrypt.conf').with(mode: '0644')
  end

  it 'writes the deploy hook at 0755' do
    expect(chef_run).to create_file('/etc/letsencrypt/renewal-hooks/deploy/01-nginx-reload').with(mode: '0755')
  end
end
