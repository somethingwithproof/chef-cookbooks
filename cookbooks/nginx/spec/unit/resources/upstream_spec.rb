# frozen_string_literal: true

require 'spec_helper'

describe 'nginx_upstream resource' do
  before do
    load File.expand_path('../../../../resources/upstream.rb', __dir__)
  end

  let(:klass) { Chef::Resource.resource_for_node(:nginx_upstream, Chef::Node.new) }
  let(:run_context) { Chef::RunContext.new(Chef::Node.new, {}, Chef::EventDispatch::Dispatcher.new) }

  it 'registers the DSL name' do
    expect(klass).not_to be_nil
  end

  it 'defaults to round_robin' do
    resource = klass.new('backends', run_context)
    expect(resource.lb_method).to eq('round_robin')
  end

  it 'rejects unknown load balancing methods' do
    resource = klass.new('backends', run_context)
    expect { resource.lb_method 'weighted_magic' }.to raise_error(Chef::Exceptions::ValidationFailed)
  end

  it 'defaults keepalive to 32' do
    resource = klass.new('backends', run_context)
    expect(resource.keepalive).to eq(32)
  end
end
