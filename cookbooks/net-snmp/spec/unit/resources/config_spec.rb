# frozen_string_literal: true

require 'spec_helper'

describe 'snmp_config resource' do
  it 'resource file loads without error' do
    expect do
      load File.expand_path('../../../../resources/config.rb', __dir__)
    end.not_to raise_error
  end

  it 'registers the resource DSL name' do
    load File.expand_path('../../../../resources/config.rb', __dir__)
    expect(Chef::Resource.resource_for_node(:snmp_config, Chef::Node.new)).not_to be_nil
  end

  it 'declares sensible defaults' do
    load File.expand_path('../../../../resources/config.rb', __dir__)
    klass = Chef::Resource.resource_for_node(:snmp_config, Chef::Node.new)
    resource = klass.new('defaults_check', Chef::RunContext.new(Chef::Node.new, {}, Chef::EventDispatch::Dispatcher.new))
    expect(resource.config_file).to eq('/etc/snmp/snmpd.conf')
    expect(resource.mode).to eq('0600')
    expect(resource.owner).to eq('root')
    expect(resource.group).to eq('root')
  end
end
