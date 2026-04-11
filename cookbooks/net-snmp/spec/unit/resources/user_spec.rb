# frozen_string_literal: true

require 'spec_helper'

describe 'snmp_user resource' do
  before do
    load File.expand_path('../../../../resources/user.rb', __dir__)
  end

  let(:klass) { Chef::Resource.resource_for_node(:snmp_user, Chef::Node.new) }
  let(:run_context) { Chef::RunContext.new(Chef::Node.new, {}, Chef::EventDispatch::Dispatcher.new) }

  it 'registers the resource DSL name' do
    expect(klass).not_to be_nil
  end

  it 'defaults to modern crypto' do
    resource = klass.new('defaults', run_context)
    expect(resource.auth_protocol).to eq('SHA-256')
    expect(resource.priv_protocol).to eq('AES-256')
    expect(resource.security_level).to eq('authPriv')
    expect(resource.access_level).to eq('ro')
  end

  it 'rejects unsupported auth protocols' do
    resource = klass.new('rejects', run_context)
    expect { resource.auth_protocol 'HMAC-RIPEMD' }.to raise_error(Chef::Exceptions::ValidationFailed)
  end

  it 'rejects unsupported priv protocols' do
    resource = klass.new('rejects', run_context)
    expect { resource.priv_protocol '3DES' }.to raise_error(Chef::Exceptions::ValidationFailed)
  end

  it 'rejects unsupported security levels' do
    resource = klass.new('rejects', run_context)
    expect { resource.security_level 'open' }.to raise_error(Chef::Exceptions::ValidationFailed)
  end
end
