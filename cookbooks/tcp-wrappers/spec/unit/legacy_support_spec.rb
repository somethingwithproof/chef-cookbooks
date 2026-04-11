# frozen_string_literal: true

require 'spec_helper'

describe 'tcp_wrappers legacy support' do
  context 'deprecation notice' do
    it 'cookbook is marked as deprecated in metadata' do
      metadata_path = File.join(File.dirname(__FILE__), '..', '..', 'metadata.rb')
      metadata_content = File.read(metadata_path)
      expect(metadata_content).to include('deprecated true')
    end

    it 'metadata includes deprecation warning in description' do
      metadata_path = File.join(File.dirname(__FILE__), '..', '..', 'metadata.rb')
      metadata_content = File.read(metadata_path)
      expect(metadata_content).to include('DEPRECATED')
    end
  end

  context 'chef version requirements' do
    it 'requires Chef 18.0 or higher' do
      metadata_path = File.join(File.dirname(__FILE__), '..', '..', 'metadata.rb')
      metadata_content = File.read(metadata_path)
      expect(metadata_content).to match(/chef_version\s+'>= 18\.0'/)
    end
  end

  context 'README documentation' do
    it 'includes deprecation notice' do
      readme_path = File.join(File.dirname(__FILE__), '..', '..', 'README.md')
      readme_content = File.read(readme_path)
      expect(readme_content).to include('Deprecated: Use firewalld instead')
    end

    it 'includes migration guide' do
      readme_path = File.join(File.dirname(__FILE__), '..', '..', 'README.md')
      readme_content = File.read(readme_path)
      expect(readme_content).to include('Migration Guide')
      expect(readme_content).to include('firewalld')
    end

    it 'includes rule conversion examples' do
      readme_path = File.join(File.dirname(__FILE__), '..', '..', 'README.md')
      readme_content = File.read(readme_path)
      expect(readme_content).to include('Rule Conversion Examples')
    end
  end
end
