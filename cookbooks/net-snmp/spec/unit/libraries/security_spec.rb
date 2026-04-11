# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../libraries/security'

describe NetSnmp::Security do
  describe '.validate_community_strings!' do
    it 'accepts an empty array' do
      expect { described_class.validate_community_strings!([]) }.not_to raise_error
    end

    it 'accepts nil' do
      expect { described_class.validate_community_strings!(nil) }.not_to raise_error
    end

    it 'accepts a unique community string hash' do
      expect { described_class.validate_community_strings!([{ 'community' => 'unique-s3cret' }]) }.not_to raise_error
    end

    it 'accepts a unique community string as a raw string' do
      expect { described_class.validate_community_strings!(['unique-s3cret']) }.not_to raise_error
    end

    it 'accepts a symbol-keyed hash' do
      expect { described_class.validate_community_strings!([{ community: 'unique-s3cret' }]) }.not_to raise_error
    end

    it 'rejects "public"' do
      expect {
        described_class.validate_community_strings!([{ 'community' => 'public' }])
      }.to raise_error(NetSnmp::Security::InsecureCommunityError, /public/)
    end

    it 'rejects "private" regardless of case' do
      expect {
        described_class.validate_community_strings!([{ 'community' => 'Private' }])
      }.to raise_error(NetSnmp::Security::InsecureCommunityError)
    end

    it 'ignores nil community entries' do
      expect { described_class.validate_community_strings!([{ 'community' => nil }]) }.not_to raise_error
    end

    it 'ignores empty community entries' do
      expect { described_class.validate_community_strings!([{ 'community' => '' }]) }.not_to raise_error
    end
  end

  describe '.extract_community' do
    it 'returns the community from a string-keyed hash' do
      expect(described_class.extract_community('community' => 'foo')).to eq('foo')
    end

    it 'returns the community from a symbol-keyed hash' do
      expect(described_class.extract_community(community: 'foo')).to eq('foo')
    end

    it 'returns the string itself when given a string' do
      expect(described_class.extract_community('foo')).to eq('foo')
    end

    it 'returns nil for unknown types' do
      expect(described_class.extract_community(123)).to be_nil
    end
  end
end
