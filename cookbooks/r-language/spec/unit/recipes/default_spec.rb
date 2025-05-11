require 'spec_helper'

describe 'r-language::default' do
  context 'when using package installation method' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['r-language']['install_method'] = 'package'
      end.converge(described_recipe)
    end

    it 'includes the package recipe' do
      expect(chef_run).to include_recipe('r-language::package')
    end

    it 'does not include the source recipe' do
      expect(chef_run).not_to include_recipe('r-language::source')
    end
  end

  context 'when using source installation method' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['r-language']['install_method'] = 'source'
      end.converge(described_recipe)
    end

    it 'includes the source recipe' do
      expect(chef_run).to include_recipe('r-language::source')
    end

    it 'does not include the package recipe' do
      expect(chef_run).not_to include_recipe('r-language::package')
    end
  end

  context 'when specifying R packages to install' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['r-language']['install_method'] = 'package'
        node.normal['r-language']['packages'] = ['dplyr', 'ggplot2']
      end.converge(described_recipe)
    end

    it 'includes the packages recipe' do
      expect(chef_run).to include_recipe('r-language::packages')
    end
  end

  context 'when not specifying R packages to install' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['r-language']['install_method'] = 'package'
        node.normal['r-language']['packages'] = []
      end.converge(described_recipe)
    end

    it 'does not include the packages recipe' do
      expect(chef_run).not_to include_recipe('r-language::packages')
    end
  end

  context 'when specifying an invalid installation method' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['r-language']['install_method'] = 'invalid'
      end
    end

    it 'raises an error' do
      expect { chef_run.converge(described_recipe) }.to raise_error(RuntimeError)
    end
  end
end