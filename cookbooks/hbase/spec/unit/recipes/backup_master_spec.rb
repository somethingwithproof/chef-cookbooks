require 'spec_helper'

describe 'hbase::backup_master' do
  context 'with default attributes' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04').converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.not_to raise_error
    end

    it 'creates the master hbase_service (backup node runs the same daemon)' do
      expect(chef_run).to create_hbase_service('master').with(
        restart_on_config_change: true,
        service_config: {}
      )
    end

    it 'enables and starts the master service' do
      expect(chef_run).to enable_hbase_service('master')
      expect(chef_run).to start_hbase_service('master')
    end
  end
end
