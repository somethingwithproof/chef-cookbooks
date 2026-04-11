# frozen_string_literal: true

require 'spec_helper'

describe 'nginx::stream' do
  before { stub_nginx_commands }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: ['nginx_stream_upstream']) do |node|
      node.normal['nginx']['stream']['upstreams'] = {
        'db_backends' => {
          'servers' => ['db1.internal:5432', 'db2.internal:5432'],
        },
      }
      node.normal['nginx']['stream']['servers'] = [
        { 'name' => 'pg_proxy', 'listen' => 5432, 'upstream' => 'db_backends' },
      ]
    end.converge(described_recipe)
  end

  it 'converges' do
    expect { chef_run }.not_to raise_error
  end

  it 'creates the stream config dir' do
    expect(chef_run).to create_directory('/etc/nginx/stream.d').with(mode: '0755')
  end

  it 'renders the stream.conf include' do
    expect(chef_run).to create_template('/etc/nginx/stream.conf').with(mode: '0644')
  end

  it 'creates stream upstream via the custom resource' do
    expect(chef_run).to create_nginx_stream_upstream('db_backends')
  end

  it 'renders a stream server block' do
    expect(chef_run).to create_template('/etc/nginx/stream.d/server_pg_proxy.conf').with(mode: '0644')
  end
end
