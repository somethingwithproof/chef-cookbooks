# frozen_string_literal: true

require 'spec_helper'

describe CookbookTemplate::Helpers do
  let(:node) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04').node }
  let(:helper_class) do
    Class.new do
      include CookbookTemplate::Helpers
      attr_reader :node
      
      def initialize(node)
        @node = node
      end
      
      def platform_family?(*families)
        families.include?(node['platform_family'])
      end
      
      def platform?(*platforms)
        platforms.include?(node['platform'])
      end
    end
  end
  let(:helper) { helper_class.new(node) }

  describe '#systemd_platform?' do
    context 'on Ubuntu 20.04' do
      it 'returns true' do
        expect(helper.systemd_platform?).to be true
      end
    end

    context 'on Ubuntu 14.04' do
      let(:node) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04').node }
      
      it 'returns false' do
        expect(helper.systemd_platform?).to be false
      end
    end

    context 'on CentOS 7' do
      let(:node) { ChefSpec::SoloRunner.new(platform: 'centos', version: '7').node }
      
      it 'returns true' do
        expect(helper.systemd_platform?).to be true
      end
    end

    context 'on CentOS 6' do
      let(:node) { ChefSpec::SoloRunner.new(platform: 'centos', version: '6').node }
      
      it 'returns false' do
        expect(helper.systemd_platform?).to be false
      end
    end
  end

  describe '#service_manager' do
    context 'on systemd platform' do
      before do
        allow(helper).to receive(:systemd_platform?).and_return(true)
      end

      it 'returns systemd' do
        expect(helper.service_manager).to eq('systemd')
      end
    end

    context 'on Ubuntu 14.04' do
      let(:node) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04').node }
      
      before do
        allow(helper).to receive(:systemd_platform?).and_return(false)
      end

      it 'returns upstart' do
        expect(helper.service_manager).to eq('upstart')
      end
    end

    context 'on older platform' do
      let(:node) { ChefSpec::SoloRunner.new(platform: 'centos', version: '6').node }
      
      before do
        allow(helper).to receive(:systemd_platform?).and_return(false)
      end

      it 'returns sysvinit' do
        expect(helper.service_manager).to eq('sysvinit')
      end
    end
  end

  describe '#config_format' do
    it 'formats hash as key=value pairs' do
      config = { 'key1' => 'value1', 'key2' => 'value2' }
      result = helper.config_format(config)
      expect(result).to include('key1=value1')
      expect(result).to include('key2=value2')
    end

    it 'formats array as comma-separated values' do
      config = %w(item1 item2 item3)
      result = helper.config_format(config)
      expect(result).to eq('item1,item2,item3')
    end

    it 'converts other types to string' do
      expect(helper.config_format(123)).to eq('123')
      expect(helper.config_format(true)).to eq('true')
    end
  end

  describe '#version_compare' do
    it 'compares versions correctly' do
      expect(helper.version_compare('1.2.3', :>, '1.2.0')).to be true
      expect(helper.version_compare('1.2.0', :<, '1.2.3')).to be true
      expect(helper.version_compare('1.2.3', :==, '1.2.3')).to be true
      expect(helper.version_compare('1.2.3', :>=, '1.2.3')).to be true
    end
  end

  describe '#valid_port?' do
    it 'validates port numbers' do
      expect(helper.valid_port?(80)).to be true
      expect(helper.valid_port?(8080)).to be true
      expect(helper.valid_port?(65535)).to be true
      expect(helper.valid_port?(0)).to be false
      expect(helper.valid_port?(65536)).to be false
      expect(helper.valid_port?('80')).to be false
    end
  end

  describe '#port_open?' do
    it 'returns false for closed port' do
      expect(helper.port_open?('localhost', 99999, 1)).to be false
    end

    it 'handles connection errors gracefully' do
      expect { helper.port_open?('invalid-host', 80, 1) }.to_not raise_error
    end
  end

  describe '#safe_file_path' do
    it 'expands and sanitizes file paths' do
      expect(helper.safe_file_path('/tmp/../etc/passwd')).to eq('/etc/passwd')
      expect(helper.safe_file_path('relative/../path')).to_not include('..')
    end
  end

  describe '#render_config' do
    before do
      allow(helper).to receive(:cookbook_name).and_return('test-cookbook')
      allow(node).to receive(:name).and_return('test-node')
    end

    it 'merges default and custom variables' do
      custom_vars = { 'custom_key' => 'custom_value' }
      result = helper.render_config(custom_vars)
      
      expect(result).to include('cookbook_name' => 'test-cookbook')
      expect(result).to include('node_name' => 'test-node')
      expect(result).to include('custom_key' => 'custom_value')
      expect(result).to have_key('timestamp')
    end
  end
end