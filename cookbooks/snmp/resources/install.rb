unified_mode true

provides :snmp_install

# SECURITY: Refuse the well-known default community strings 'public' and
# 'private'. These are scanned for by every commodity SNMP discovery tool on
# the public internet and are the most common cause of SNMP information
# disclosure. The validator is a lambda local to the property so the file can
# be reloaded without Ruby constant-redefined warnings.
strong_community = lambda do |c|
  s = c.to_s
  !s.empty? && !%w(public private).include?(s.downcase)
end

property :community, String,
         description: 'SNMP community string (required, must not be empty or "public"/"private")',
         default: lazy { node['snmp']['community'] },
         callbacks: {
           'must be explicitly configured and must not be the well-known defaults "public" or "private"' => strong_community,
         }

property :trap_community, String,
         description: 'SNMP trap community string (required, must not be empty or "public"/"private")',
         default: lazy { node['snmp']['trap']['community'] },
         callbacks: {
           'must be explicitly configured and must not be the well-known defaults "public" or "private"' => strong_community,
         }

property :trap_addresses, Array,
         description: 'Array of trap addresses',
         default: []

property :trap_port, Integer,
         description: 'SNMP trap port',
         default: 162,
         callbacks: {
           'must be a valid port number' => ->(p) { p.between?(1, 65535) },
         }

property :groups, Hash,
         description: 'Hash of SNMP groups',
         default: {}

property :sec_name, Hash,
         description: 'Hash of security names. Source must be an explicit network or "localhost".',
         default: lazy { node['snmp']['sec_name'] }

property :sec_name6, Hash,
         description: 'Hash of IPv6 security names. Source must be an explicit network or "::1".',
         default: lazy { node['snmp']['sec_name6'] }

default_action :install

action_class do
  def platform_config
    {
      'rhel' => {
        package: 'net-snmp',
        service: 'snmpd',
        conf_file: '/etc/snmp/snmpd.conf',
      },
      'debian' => {
        package: 'snmpd',
        service: 'snmpd',
        conf_file: '/etc/snmp/snmpd.conf',
      },
      'suse' => {
        package: 'net-snmp',
        service: 'snmpd',
        conf_file: '/etc/snmp/snmpd.conf',
      },
      'solaris2' => {
        package: 'SUNWucsnmp',
        service: 'svc:/network/snmp/dmi:default',
        conf_file: '/etc/sma/snmp/snmpd.conf',
      },
      'aix' => {
        package: 'net-snmp',
        service: 'snmpd',
        conf_file: '/etc/snmpd.conf',
      },
      'mac_os_x' => {
        package: 'net-snmp',
        service: 'org.net-snmp.snmpd',
        conf_file: '/usr/local/etc/snmp/snmpd.conf',
      },
    }[node['platform_family']] || {
      package: 'net-snmp',
      service: 'snmpd',
      conf_file: '/etc/snmp/snmpd.conf',
    }
  end
end

action :install do
  config = platform_config

  # SECURITY: Reject all-hosts wildcards in the com2sec source list. The
  # net-snmp keywords 'default' and '0.0.0.0/0' grant access from any host;
  # the cookbook requires an explicit network or 'localhost'.
  forbidden_sources = %w(default 0.0.0.0/0 ::/0).freeze
  [new_resource.sec_name, new_resource.sec_name6].each do |group|
    group.each_value do |sources|
      bad = Array(sources).map(&:to_s).map(&:downcase) & forbidden_sources
      next if bad.empty?
      raise "snmp_install: refusing wildcard source(s) #{bad.inspect} in com2sec; " \
            'set node[\'snmp\'][\'sec_name\'] to an explicit network (e.g. "10.0.0.0/8") or "localhost"'
    end
  end

  # Install SNMP package
  package config[:package]

  # Configure Debian-specific default file
  template '/etc/default/snmpd' do
    source 'snmpd.erb'
    cookbook 'snmp'
    mode '0644'
    owner 'root'
    group 'root'
    sensitive false # This file contains no secrets
    only_if { platform_family?('debian') }
  end

  # Enable and start SNMP service
  service config[:service] do
    action [:enable, :start]
  end

  # Configure SNMP with platform-specific configuration file
  template config[:conf_file] do
    source 'snmpd.conf.erb'
    cookbook 'snmp'
    mode '0600'
    owner 'root'
    group 'root'
    sensitive true # Contains community strings (credentials)
    variables(
      community: new_resource.community,
      groups: new_resource.groups.keys.uniq,
      sec_name: new_resource.sec_name,
      sec_name6: new_resource.sec_name6
    )
    notifies :restart, "service[#{config[:service]}]"
  end
end
