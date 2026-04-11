# frozen_string_literal: true

require 'spec_helper'

describe 'nginx::sites' do
  before { stub_nginx_commands }

  context 'default site enabled on debian' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04').converge(described_recipe)
    end

    it 'creates the default site template' do
      expect(chef_run).to create_template('/etc/nginx/sites-enabled/default.conf').with(mode: '0644')
    end

    it 'creates the document root' do
      expect(chef_run).to create_directory('/var/www/html')
    end

    it 'writes index.html only if missing' do
      expect(chef_run).to create_file_if_missing('/var/www/html/index.html')
    end
  end

  context 'default site disabled' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['nginx']['default_site']['enabled'] = false
      end.converge(described_recipe)
    end

    it 'does not render the default template' do
      expect(chef_run).not_to create_template('/etc/nginx/sites-enabled/default.conf')
    end
  end

  context 'with custom sites' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['nginx']['sites'] = {
          'example' => {
            'domain' => 'example.com',
            'port'   => 8080,
            'root'   => '/srv/www/example',
          },
          'secure' => {
            'domain'      => 'secure.example.com',
            'ssl_enabled' => true,
            'ssl_cert'    => '/etc/ssl/certs/secure.crt',
            'ssl_key'     => '/etc/ssl/private/secure.key',
          },
        }
      end.converge(described_recipe)
    end

    it 'renders a template per site in sites-available' do
      expect(chef_run).to create_template('/etc/nginx/sites-available/example.conf').with(mode: '0644')
      expect(chef_run).to create_template('/etc/nginx/sites-available/secure.conf').with(mode: '0644')
    end

    it 'symlinks the site into sites-enabled on debian' do
      expect(chef_run).to create_link('/etc/nginx/sites-enabled/example.conf')
      expect(chef_run).to create_link('/etc/nginx/sites-enabled/secure.conf')
    end

    it 'creates each document root' do
      expect(chef_run).to create_directory('/srv/www/example')
      expect(chef_run).to create_directory('/var/www/secure')
    end
  end
end
