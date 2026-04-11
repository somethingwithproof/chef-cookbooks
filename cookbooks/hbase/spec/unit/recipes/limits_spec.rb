require 'spec_helper'

describe 'hbase::limits' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04').converge(described_recipe)
  end

  it 'converges successfully' do
    expect { chef_run }.not_to raise_error
  end

  it 'writes the PAM limits file with default caps' do
    expect(chef_run).to create_template('/etc/security/limits.d/hbase.conf').with(
      mode: '0644',
      variables: {
        user: 'hbase',
        nofile: 32_768,
        nproc: 65_536,
      }
    )
  end

  context 'with custom limits' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'almalinux', version: '8')
      runner.node.override['hbase']['limits']['nofile'] = 100_000
      runner.node.override['hbase']['limits']['nproc']  = 200_000
      runner.converge(described_recipe)
    end

    it 'propagates overrides into the template variables' do
      resource = chef_run.template('/etc/security/limits.d/hbase.conf')
      expect(resource.variables[:nofile]).to eq(100_000)
      expect(resource.variables[:nproc]).to eq(200_000)
    end
  end
end
