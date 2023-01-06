control 'snmp-config' do
    impact 1.0
    title 'SNMP configuration'
    desc 'The SNMP configuration file should be properly configured'
  
    case os[:family]
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
  
    describe file(conf_file) do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 600 }
    end
  
    # Parse the SNMP configuration file and check that the required groups are present
    groups = {}
    File.readlines(conf_file).each do |line|
      if line =~ /^group (\S+) (\S+) (.*)$/
        group, sec_model, read_view = Regexp.last_match(1), Regexp.last_match(2), Regexp.last_match(3)
        groups[group] = { sec_model: sec_model, read_view: read_view }
      end
    end
  
    # Load the node attributes
    node_groups = attribute('snmp.groups')
  
    # Check that all required groups are present in the configuration file
    node_groups.each do |group, attrs|
      describe groups[group] do
        it { should_not be_nil }
        its(:sec_model) { should eq attrs['sec_model'] }
        its(:read_view) { should eq attrs['read_view'] }
      end
    end
  end
  