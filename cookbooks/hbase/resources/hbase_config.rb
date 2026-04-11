unified_mode true

provides :hbase_config

property :path,             String, name_property: true
property :user,             String, default: lazy { node['hbase']['user'] }
property :group,            String, default: lazy { node['hbase']['group'] }
property :mode,             String, default: '0644'
property :variables,        Hash,   default: {}
property :config_type,      String, equal_to: %w(xml properties env script), default: 'xml'
property :template_source,  String
property :restart_services, Array,  default: []
property :use_helpers,      [true, false], default: false

TEMPLATE_FOR_TYPE = {
  'xml'        => 'hbase-site.xml.erb',
  'properties' => 'log4j2.properties.erb',
  'env'        => 'hbase-env.sh.erb',
  'script'     => 'generic-script.erb',
}.freeze

action_class do
  def determine_template_source
    new_resource.template_source || TEMPLATE_FOR_TYPE.fetch(new_resource.config_type)
  end

  # When use_helpers is set on an XML file we wrap the caller's hash so the
  # ERB template sees it under @config and gets validate_config's defaults.
  def process_variables
    if new_resource.use_helpers && new_resource.config_type == 'xml'
      { config: validate_config(new_resource.variables) }
    else
      new_resource.variables
    end
  end
end

action :create do
  directory ::File.dirname(new_resource.path) do
    owner new_resource.user
    group new_resource.group
    mode '0755'
    recursive true
    action :create
  end

  restart_services = new_resource.restart_services

  template new_resource.path do
    source determine_template_source
    cookbook 'hbase'
    owner new_resource.user
    group new_resource.group
    mode new_resource.mode
    variables process_variables
    action :create

    restart_services.each do |svc|
      notifies :restart, "service[hbase-#{svc}]", :delayed
    end
  end
end
