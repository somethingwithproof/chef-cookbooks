unified_mode true

provides :snmp_trapd

property :trap_community, String,
         description: 'SNMP trap community string',
         default: 'public'

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
    mode '0644'
    owner 'root'
    group 'root'
    variables(
      trap_community: new_resource.trap_community,
      trap_addresses: new_resource.trap_addresses,
      trap_port: new_resource.trap_port
    )
    notifies :restart, "service[#{service_name}]"
  end
end
