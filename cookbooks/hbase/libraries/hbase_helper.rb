module HBase
  # Helpers mixed into recipe and resource DSL. Callers access `node` via the
  # including context, so these methods only need to be mixed in once.
  module Helper
    # Serializes a hash of HBase properties as the body of hbase-site.xml.
    # Keys are sorted to produce deterministic diffs on re-render.
    def config_to_xml_properties(config = {})
      config.sort.map do |key, value|
        <<~XML.chomp
          <property>
            <name>#{key}</name>
            <value>#{value}</value>
          </property>
        XML
      end.join("\n")
    end

    # Merges caller-supplied properties over the three required defaults so
    # partial overrides never drop essentials.
    def validate_config(config = {})
      {
        'hbase.rootdir' => node['hbase']['config']['hbase.rootdir'],
        'hbase.zookeeper.quorum' => node['hbase']['config']['hbase.zookeeper.quorum'],
        'hbase.cluster.distributed' => node['hbase']['config']['hbase.cluster.distributed'],
      }.merge(config)
    end

    def hbase_principal
      return unless node['hbase']['security']['authentication'] == 'kerberos'
      principal = node['hbase']['security']['kerberos']['principal']
      "#{principal}@#{node['hbase']['security']['kerberos']['realm']}"
    end

    def zk_connection_string
      quorum = node['hbase']['config']['hbase.zookeeper.quorum'].to_s.split(',')
      port = node['hbase']['config']['hbase.zookeeper.property.clientPort'] || 2181
      quorum.map { |host| "#{host}:#{port}" }.join(',')
    end

    def master?
      node['hbase']['topology']['role'] == 'master'
    end

    def regionserver?
      node['hbase']['topology']['role'] == 'regionserver'
    end

    def backup_master?
      node['hbase']['topology']['role'] == 'backup_master'
    end

    # Searches for cluster peers by role. Silences the expected search failure
    # path inside ChefSpec where no server is reachable.
    def nodes_with_role(role, environment = node.chef_environment)
      results = search(:node, "chef_environment:#{environment} AND hbase_topology_role:#{role}")
      results.sort_by { |n| n['name'] }
    rescue Net::HTTPClientException, Chef::Exceptions::InvalidDataBagPath => e
      Chef::Log.warn("hbase: search for role=#{role} failed: #{e.message}")
      []
    end

    # Builds the JVM argument string used for every HBase daemon.
    def java_options
      opts = +node['hbase']['java_opts'].to_s
      if node['hbase']['security']['authentication'] == 'kerberos'
        opts << " -Djava.security.auth.login.config=#{node['hbase']['conf_dir']}/jaas.conf"
      end
      opts << " -Dhbase.log.dir=#{node['hbase']['log_dir']}"
      opts << " -Dhbase.security.logger=#{node['hbase']['log_level']},console"
      opts
    end
  end
end

Chef::DSL::Recipe.include(HBase::Helper)
Chef::DSL::Resource.include(HBase::Helper) if defined?(Chef::DSL::Resource)
