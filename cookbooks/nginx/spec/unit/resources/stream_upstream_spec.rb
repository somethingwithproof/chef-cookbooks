# frozen_string_literal: true

require 'spec_helper'

describe 'nginx_stream_upstream resource' do
  before do
    load File.expand_path('../../../../resources/stream_upstream.rb', __dir__)
  end

  let(:klass) { Chef::Resource.resource_for_node(:nginx_stream_upstream, Chef::Node.new) }
  let(:run_context) { Chef::RunContext.new(Chef::Node.new, {}, Chef::EventDispatch::Dispatcher.new) }

  it 'registers the DSL name' do
    expect(klass).not_to be_nil
  end

  it 'defaults to round_robin' do
    resource = klass.new('pg_backends', run_context)
    expect(resource.lb_method).to eq('round_robin')
  end

  it 'rejects ip_hash (not supported by stream)' do
    resource = klass.new('pg_backends', run_context)
    expect { resource.lb_method 'ip_hash' }.to raise_error(Chef::Exceptions::ValidationFailed)
  end

  it 'defaults zone_size to 64k' do
    resource = klass.new('pg_backends', run_context)
    expect(resource.zone_size).to eq('64k')
  end
end
