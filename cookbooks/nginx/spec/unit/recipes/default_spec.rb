# frozen_string_literal: true

require 'spec_helper'

describe 'nginx::default' do
  SUPPORTED_PLATFORMS.each do |p|
    context "on #{p[:platform]} #{p[:version]}" do
      before { stub_nginx_commands }

      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: p[:platform], version: p[:version]) do |node|
          node.automatic['fqdn'] = 'spec.example.com'
        end.converge(described_recipe)
      end

      it 'converges' do
        expect { chef_run }.not_to raise_error
      end

      it 'enables nginx' do
        expect(chef_run).to enable_service('nginx')
      end

      it 'starts nginx' do
        expect(chef_run).to start_service('nginx')
      end

      it 'renders /etc/nginx/nginx.conf' do
        expect(chef_run).to create_template('/etc/nginx/nginx.conf').with(mode: '0644')
      end

      it 'renders the security include' do
        expect(chef_run).to create_template('/etc/nginx/conf.d/security.conf').with(mode: '0644')
      end
    end
  end

  context 'debian family install path' do
    before { stub_nginx_commands }

    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04').converge(described_recipe)
    end

    it 'installs via apt-get execute' do
      expect(chef_run).to run_execute('install-nginx')
    end
  end

  context 'rhel family install path' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'rocky', version: '9').converge(described_recipe)
    end

    it 'creates the upstream nginx repo' do
      expect(chef_run).to create_yum_repository('nginx')
    end

    it 'installs the nginx package' do
      expect(chef_run).to install_package('nginx')
    end
  end
end
