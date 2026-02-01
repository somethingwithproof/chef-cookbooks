require 'spec_helper'

describe 'vagrant_example::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04').converge(described_recipe)
  end

  it 'converges successfully' do
    expect { chef_run }.not_to raise_error
  end

  it 'logs a message' do
    expect(chef_run).to write_log('vagrant_example')
  end
end
