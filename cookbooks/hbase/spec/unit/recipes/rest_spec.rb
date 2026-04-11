require 'spec_helper'

describe 'hbase::rest' do
  context 'with default attributes' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04').converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.not_to raise_error
    end

    it 'creates the rest hbase_service' do
      expect(chef_run).to create_hbase_service('rest').with(
        restart_on_config_change: true,
        service_config: {}
      )
    end

    it 'enables and starts the rest service' do
      expect(chef_run).to enable_hbase_service('rest')
      expect(chef_run).to start_hbase_service('rest')
    end
  end

  context 'with custom rest config' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04')
      runner.node.override['hbase']['services']['rest']['config'] = {
        'hbase.rest.port' => 8181,
      }
      runner.converge(described_recipe)
    end

    it 'passes the override through to the resource' do
      resource = chef_run.find_resource(:hbase_service, 'rest')
      expect(resource.service_config.to_h).to eq('hbase.rest.port' => 8181)
    end
  end
end
