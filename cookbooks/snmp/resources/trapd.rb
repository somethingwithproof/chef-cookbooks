unified_mode true

provides :snmp_trapd

# SECURITY: Refuse the well-known default community strings 'public' and 'private'.
strong_trap_community = lambda do |c|
  s = c.to_s
  !s.empty? && !%w(public private).include?(s.downcase)
end

property :trap_community, String,
         description: 'SNMP trap community string (required, must not be empty or "public"/"private")',
         default: lazy { node['snmp']['trap']['community'] },
         callbacks: {
           'must be explicitly configured and must not be the well-known defaults "public" or "private"' => strong_trap_community,
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

property :trap_service, String,
         description: 'SNMP trap service name (platform-dependent)'

default_action :install

action :install do
  # Get the appropriate service name
  service_name = new_resource.trap_service || node['snmp']['snmptrapd']['service_name']

  # Configure SNMPD to run snmptrapd - using Chef 16+ attribute pattern
  node.override['snmp']['snmptrapd']['trapd_run'] = 'yes'

  # Include the main SNMP installation
  snmp_install 'default' do
    action :install
    trap_community new_resource.trap_community
    trap_addresses new_resource.trap_addresses
    trap_port new_resource.trap_port
  end

  # Configure and enable snmptrapd
  service service_name do
    action [:enable, :start]
  end

  # Configure snmptrapd
  template '/etc/snmp/snmptrapd.conf' do
    source 'snmptrapd.conf.erb'
    cookbook 'snmp'
    mode '0600'
    owner 'root'
    group 'root'
    sensitive true # Contains community strings (credentials)
    variables(
      trap_community: new_resource.trap_community,
      trap_addresses: new_resource.trap_addresses,
      trap_port: new_resource.trap_port
    )
    notifies :restart, "service[#{service_name}]"
  end
end
