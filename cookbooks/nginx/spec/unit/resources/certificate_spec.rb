# frozen_string_literal: true

require 'spec_helper'

describe 'nginx_certificate resource' do
  before do
    load File.expand_path('../../../../resources/certificate.rb', __dir__)
  end

  let(:klass) { Chef::Resource.resource_for_node(:nginx_certificate, Chef::Node.new) }
  let(:run_context) { Chef::RunContext.new(Chef::Node.new, {}, Chef::EventDispatch::Dispatcher.new) }

  it 'registers the DSL name' do
    expect(klass).not_to be_nil
  end

  it 'requires an email' do
    resource = klass.new('example.com', run_context)
    expect(resource.email).to be_nil
  end

  it 'defaults key_size to 4096' do
    resource = klass.new('example.com', run_context)
    expect(resource.key_size).to eq(4096)
  end

  it 'defaults to letsencrypt provider' do
    resource = klass.new('example.com', run_context)
    expect(resource.cert_provider).to eq('letsencrypt')
  end

  it 'rejects unknown providers' do
    resource = klass.new('example.com', run_context)
    expect { resource.cert_provider 'acme-v1' }.to raise_error(Chef::Exceptions::ValidationFailed)
  end

  it 'lazily resolves certificate_path from the domain' do
    resource = klass.new('example.com', run_context)
    expect(resource.certificate_path).to eq('/etc/letsencrypt/live/example.com/fullchain.pem')
  end
end
