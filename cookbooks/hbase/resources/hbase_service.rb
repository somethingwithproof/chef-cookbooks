unified_mode true

provides :hbase_service

property :service_name, String, name_property: true
property :user,        String, default: lazy { node['hbase']['user'] }
property :group,       String, default: lazy { node['hbase']['group'] }
property :install_dir, String, default: lazy { node['hbase']['install_dir'] }
property :log_dir,     String, default: lazy { node['hbase']['log_dir'] }
property :pid_dir,     String, default: lazy { node['hbase']['pid_dir'] }
property :conf_dir,    String, default: lazy { node['hbase']['conf_dir'] }
property :java_home,   String, default: lazy { node['hbase']['java_home'] }
property :java_opts,   String, default: lazy { node['hbase']['java_opts'] }
property :limit_nofile, Integer, default: lazy { node['hbase']['limits']['nofile'] }
property :limit_nproc,  Integer, default: lazy { node['hbase']['limits']['nproc'] }
property :restart_on_config_change, [true, false], default: true
property :service_config, Hash, default: {}

action_class do
  # systemd unit name and service resource name are kept in sync so the
  # notifies: targets in create_service_config always match an existing
  # resource.
  def unit_name
    "hbase-#{new_resource.service_name}.service"
  end

  def service_resource_name
    "hbase-#{new_resource.service_name}"
  end

  def create_service_config
    return if new_resource.service_config.empty?

    notify_target = unit_name
    restart = new_resource.restart_on_config_change

    template "#{new_resource.conf_dir}/#{new_resource.service_name}-site.xml" do
      source 'service-site.xml.erb'
      cookbook 'hbase'
      owner new_resource.user
      group new_resource.group
      mode '0644'
      variables(config: new_resource.service_config)
      action :create
      notifies :restart, "systemd_unit[#{notify_target}]", :delayed if restart
    end
  end
end

action :create do
  systemd_unit unit_name do
    content(
      Unit: {
        Description: "Apache HBase #{new_resource.service_name.capitalize} Service",
        After: 'network.target',
        Documentation: 'https://hbase.apache.org',
      },
      Service: {
        Type: 'forking',
        User: new_resource.user,
        Group: new_resource.group,
        Environment: [
          "JAVA_HOME=#{new_resource.java_home}",
          "HBASE_OPTS=#{new_resource.java_opts}",
          "HBASE_PID_DIR=#{new_resource.pid_dir}",
          "HBASE_LOG_DIR=#{new_resource.log_dir}",
        ],
        ExecStart: "#{new_resource.install_dir}/bin/hbase-daemon.sh start #{new_resource.service_name}",
        ExecStop: "#{new_resource.install_dir}/bin/hbase-daemon.sh stop #{new_resource.service_name}",
        Restart: 'on-failure',
        RestartSec: 10,
        TimeoutStartSec: 120,
        LimitNOFILE: new_resource.limit_nofile,
        LimitNPROC: new_resource.limit_nproc,
        PIDFile: "#{new_resource.pid_dir}/hbase-#{new_resource.user}-#{new_resource.service_name}.pid",
      },
      Install: {
        WantedBy: 'multi-user.target',
      }
    )
    verify false
    action :create
  end

  create_service_config
end

action :enable do
  service service_resource_name do
    action :enable
  end
end

action :start do
  service service_resource_name do
    action :start
  end
end

action :restart do
  service service_resource_name do
    action :restart
  end
end

action :disable do
  service service_resource_name do
    action :disable
  end
end

action :stop do
  service service_resource_name do
    action :stop
  end
end
