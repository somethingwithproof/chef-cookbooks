# frozen_string_literal: true

require 'spec_helper'

describe 'nginx::configure' do
  before { stub_nginx_commands }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04').converge(described_recipe)
  end

  it 'converges' do
    expect { chef_run }.not_to raise_error
  end

  it 'creates /etc/nginx/conf.d' do
    expect(chef_run).to create_directory('/etc/nginx/conf.d').with(mode: '0755')
  end

  it 'creates the debian sites-available dir' do
    expect(chef_run).to create_directory('/etc/nginx/sites-available').with(mode: '0755')
  end

  it 'generates dhparam by default' do
    expect(chef_run).to run_execute('generate-dhparam')
  end

  it 'renders nginx.conf with a delayed reload' do
    expect(chef_run.template('/etc/nginx/nginx.conf')).to notify('service[nginx]').to(:reload).delayed
  end

  it 'renders security.conf at 0644' do
    expect(chef_run).to create_template('/etc/nginx/conf.d/security.conf').with(mode: '0644')
  end

  it 'renders ssl.conf when ssl is enabled' do
    expect(chef_run).to create_template('/etc/nginx/conf.d/ssl.conf')
  end

  it 'renders status.conf when a monitoring path is set' do
    expect(chef_run).to create_template('/etc/nginx/conf.d/status.conf')
  end

  context 'with ssl disabled' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04') do |node|
        node.normal['nginx']['ssl']['enabled'] = false
      end.converge(described_recipe)
    end

    it 'does not run dhparam' do
      expect(chef_run).not_to run_execute('generate-dhparam')
    end

    it 'does not render ssl.conf' do
      expect(chef_run).not_to create_template('/etc/nginx/conf.d/ssl.conf')
    end
  end
end
