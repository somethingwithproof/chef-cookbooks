# frozen_string_literal: true

# Guardrails for SNMPv1/v2c community strings and v3 credentials.
#
# Community strings are cleartext on the wire. "public" and "private"
# are the canonical defaults attackers scan for; refusing to configure
# them forces operators to pick something unique (or switch to SNMPv3).
module NetSnmp
  module Security
    BANNED_COMMUNITIES = %w(public private).freeze

    class InsecureCommunityError < StandardError; end

    module_function

    def validate_community_strings!(entries)
      Array(entries).each do |entry|
        community = extract_community(entry)
        next if community.nil? || community.empty?

        if BANNED_COMMUNITIES.include?(community.downcase)
          raise InsecureCommunityError,
                "SNMP community string #{community.inspect} is a well-known default and is refused. " \
                'Set a unique string or use SNMPv3.'
        end
      end
    end

    def extract_community(entry)
      case entry
      when Hash
        entry['community'] || entry[:community]
      when String
        entry
      end
    end
  end
end
