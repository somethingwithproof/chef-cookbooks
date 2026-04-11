require 'spec_helper'

describe 'hbase::java' do
  context 'on Ubuntu 22.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04').converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.not_to raise_error
    end

    it 'installs the openjdk package' do
      expect(chef_run).to install_package('openjdk-11-jdk')
    end

    it 'derives JAVA_HOME for debian layout' do
      expect(chef_run.node['hbase']['java_home']).to eq('/usr/lib/jvm/java-11-openjdk-amd64')
    end

    it 'writes the profile.d stub' do
      expect(chef_run).to create_file('/etc/profile.d/java_home.sh').with(
        mode: '0755',
        content: "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64\n"
      )
    end

    it 'queues the verification ruby_block' do
      expect(chef_run).to run_ruby_block('verify_java_installation')
    end
  end

  context 'on AlmaLinux 8' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'almalinux', version: '8').converge(described_recipe)
    end

    it 'installs the RHEL openjdk-devel package' do
      expect(chef_run).to install_package('java-11-openjdk-devel')
    end

    it 'derives JAVA_HOME for rhel layout' do
      expect(chef_run.node['hbase']['java_home']).to eq('/usr/lib/jvm/java-11-openjdk')
    end
  end

  context 'on Amazon Linux 2023' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'amazon', version: '2023').converge(described_recipe)
    end

    it 'installs the amazon openjdk-devel package' do
      expect(chef_run).to install_package('java-11-openjdk-devel')
    end
  end

  context 'when java_home is set explicitly' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04')
      runner.node.override['hbase']['java_home'] = '/opt/java'
      runner.converge(described_recipe)
    end

    it 'honors the override' do
      expect(chef_run.node['hbase']['java_home']).to eq('/opt/java')
    end
  end
end
