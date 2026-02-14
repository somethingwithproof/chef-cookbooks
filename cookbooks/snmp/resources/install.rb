unified_mode true

provides :snmp_install

property :community, String,
         description: 'SNMP community string (required for security)',
         default: lazy { node['snmp']['community'] },
         callbacks: {
           'cannot be empty - must explicitly configure community string' => ->(c) { !c.to_s.empty? },
         }

property :trap_community, String,
         description: 'SNMP trap community string (required for security)',
         default: lazy { node['snmp']['trap']['community'] },
         callbacks: {
           'cannot be empty - must explicitly configure trap community string' => ->(c) { !c.to_s.empty? },
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
         description: 'Hash of security names',
         default: { notConfigUser: %w(default) }

property :sec_name6, Hash,
         description: 'Hash of IPv6 security names',
         default: { notConfigUser: %w(default) }

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
