require 'chefspec'

describe 'snmp::default' do
  platforms = {
    'redhat' => '6.9',
    'centos' => '6.9',
    'fedora' => '29',
    'amazon' => '2018.03',
    'debian' => '9.5',
    'ubuntu' => '16.04',
    'solaris2' => '5.11',
    'aix' => '7.1',
    'mac_os_x' => '10.13'
  }

  platforms.each do |platform, version|
    context "on #{platform} #{version}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: platform, version: version).converge(described_recipe)
      end

      it 'installs the required SNMP package' do
        case platform
        when 'redhat', 'centos', 'fedora', 'amazon'
          pkg = 'net-snmp'
        when 'debian', 'ubuntu'
          pkg = 'snmpd'
        when 'solaris2'
          pkg = 'SUNWucsnmp'
        when 'aix'
          pkg = 'net-snmp'
        when 'mac_os_x'
          pkg = 'net-snmp'
        end
        expect(chef_run).to install_package(pkg)
      end

      it 'creates the /etc/default/snmpd template' do
        expect(chef_run).to create_template('/etc/default/snmpd').with(
          mode: '0644',
          owner: 'root',
          group: 'root'
        )
      end

      it 'starts and enables the SNMP daemon service' do
        case platform
        when 'redhat', 'centos', 'fedora', 'amazon'
          service_name = 'snmpd'
        when 'debian', 'ubuntu'
          service_name = 'snmpd'
        when 'solaris2'
          service_name = 'svc:/network/snmp/dmi:default'
        when 'aix'
          service_name = 'snmpd'
        when 'mac_os_x'
          service_name = 'org.net-snmp.snmpd'
        end
        expect(chef_run).to start_service(service_name)
        expect(chef_run).to enable_service(service_name)
      end

      it 'creates the SNMP daemon configuration file' do
        case platform
        when 'redhat', 'centos', 'fedora', 'amazon'
          conf_file = '/etc/snmp/snmpd.conf'
        when 'debian', 'ubuntu'
          conf_file = '/etc/snmp/snmpd.conf'
        when 'solaris2'
          conf_file = '/etc/sma/snmp/snmpd.conf'
        when 'aix'
          conf_file = '/etc/snmpd.conf
          it 'creates the SNMP daemon configuration file' do
            case platform
            when 'redhat', 'centos', 'fedora', 'amazon'
              conf_file = '/etc/snmp/snmpd.conf'
            when 'debian', 'ubuntu'
              conf_file = '/etc/snmp/snmpd.conf'
            when 'solaris2'
              conf_file = '/etc/sma/snmp/snmpd.conf'
            when 'aix'
              conf_file = '/etc/snmpd.conf'
            when 'mac_os_x'
              conf_file = '/usr/local/etc/snmp/snmpd.conf'
            end
            expect(chef_run).to create_template(conf_file).with(
              mode: '0600',
              owner: 'root',
              group: 'root'
            )
          end
        end
      end
    end
    