# frozen_string_literal: true

unified_mode true

provides :snmp_trap_receiver

description 'Manages snmptrapd configuration for receiving SNMP traps'

property :listen_address, String,
         default: 'udp:162',
         description: 'Address and port to listen for traps'

property :community, String,
         description: 'SNMPv1/v2c community string for traps'

property :v3_users, Array,
         default: [],
         description: 'SNMPv3 users for authenticated traps'

property :log_type, String,
         equal_to: %w(syslog file execute),
         default: 'syslog',
         description: 'How to log/handle received traps'

property :log_file, String,
         default: '/var/log/snmptrapd.log',
         description: 'Log file path when log_type is file'

property :trap_handler, String,
         description: 'Script to execute when trap is received'

property :forward_addresses, Array,
         default: [],
         description: 'Addresses to forward traps to'

property :auth_required, [true, false],
         default: true,
         description: 'Require authentication for traps'

property :config_file, String,
         default: '/etc/snmp/snmptrapd.conf',
         description: 'Path to snmptrapd.conf'

action :create do
  NetSnmp::Security.validate_community_strings!(
    [{ 'community' => new_resource.community }]
  ) if new_resource.community

  case node['platform_family']
  when 'rhel', 'fedora', 'amazon'
    package 'net-snmp-utils' do
      action :install
    end
  when 'debian'
    package 'snmptrapd' do
      action :install
    end
  end

  template new_resource.config_file do
    source 'snmptrapd.conf.erb'
    cookbook 'net-snmp'
    owner 'root'
    group 'root'
    mode '0600'
    sensitive true
    variables(
      listen_address: new_resource.listen_address,
      community: new_resource.community,
      v3_users: new_resource.v3_users,
      log_type: new_resource.log_type,
      log_file: new_resource.log_file,
      trap_handler: new_resource.trap_handler,
      forward_addresses: new_resource.forward_addresses,
      auth_required: new_resource.auth_required
    )
    notifies :restart, 'service[snmptrapd]', :delayed
  end
end

action :enable do
  service 'snmptrapd' do
    action %i(enable start)
  end
end

action :disable do
  service 'snmptrapd' do
    action %i(stop disable)
  end
end

action :delete do
  file new_resource.config_file do
    action :delete
    notifies :stop, 'service[snmptrapd]', :before
  end
end
