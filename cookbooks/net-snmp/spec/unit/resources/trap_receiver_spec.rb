# frozen_string_literal: true

require 'spec_helper'

describe 'snmp_trap_receiver resource' do
  before do
    load File.expand_path('../../../../resources/trap_receiver.rb', __dir__)
  end

  it 'registers the resource DSL name' do
    expect(Chef::Resource.resource_for_node(:snmp_trap_receiver, Chef::Node.new)).not_to be_nil
  end

  it 'declares secure-by-default properties' do
    klass = Chef::Resource.resource_for_node(:snmp_trap_receiver, Chef::Node.new)
    resource = klass.new('defaults', Chef::RunContext.new(Chef::Node.new, {}, Chef::EventDispatch::Dispatcher.new))
    expect(resource.listen_address).to eq('udp:162')
    expect(resource.auth_required).to be(true)
    expect(resource.log_type).to eq('syslog')
    expect(resource.config_file).to eq('/etc/snmp/snmptrapd.conf')
  end

  it 'rejects banned community strings through the shared validator' do
    expect {
      NetSnmp::Security.validate_community_strings!([{ 'community' => 'public' }])
    }.to raise_error(NetSnmp::Security::InsecureCommunityError)
  end
end
