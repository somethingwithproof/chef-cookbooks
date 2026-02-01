# frozen_string_literal: true

#
# Cookbook:: net-snmp
# Recipe:: prometheus_exporter
#
# Copyright:: 2025-2026, Thomas Vincent
# License:: Apache-2.0
#

# Install and configure Prometheus SNMP Exporter
# https://github.com/prometheus/snmp_exporter

exporter_version = node['net_snmp']['prometheus']['exporter_version']
exporter_port = node['net_snmp']['prometheus']['port']
exporter_user = node['net_snmp']['prometheus']['user']
exporter_group = node['net_snmp']['prometheus']['group']

# Create user and group for exporter
group exporter_group do
  system true
  action :create
end

user exporter_user do
  system true
  gid exporter_group
  shell '/sbin/nologin'
  home '/var/lib/snmp_exporter'
  action :create
end

# Create directories
directory '/var/lib/snmp_exporter' do
  owner exporter_user
  group exporter_group
  mode '0755'
  action :create
end

directory '/etc/snmp_exporter' do
  owner 'root'
  group exporter_group
  mode '0755'
  action :create
end

# Download and install snmp_exporter
ark 'snmp_exporter' do
  url "https://github.com/prometheus/snmp_exporter/releases/download/v#{exporter_version}/snmp_exporter-#{exporter_version}.linux-amd64.tar.gz"
  version exporter_version
  checksum node['net_snmp']['prometheus']['checksum'] if node['net_snmp']['prometheus']['checksum']
  has_binaries ['snmp_exporter']
  action :install
  only_if { platform_family?('debian', 'rhel', 'fedora', 'amazon') }
end

# Generate snmp.yml configuration
template '/etc/snmp_exporter/snmp.yml' do
  source 'snmp_exporter.yml.erb'
  cookbook 'net-snmp'
  owner 'root'
  group exporter_group
  mode '0644'
  variables(
    modules: node['net_snmp']['prometheus']['modules']
  )
  notifies :restart, 'service[snmp_exporter]', :delayed
end

# Create systemd service file
systemd_unit 'snmp_exporter.service' do
  content <<~UNIT
    [Unit]
    Description=Prometheus SNMP Exporter
    Documentation=https://github.com/prometheus/snmp_exporter
    Wants=network-online.target
    After=network-online.target

    [Service]
    Type=simple
    User=#{exporter_user}
    Group=#{exporter_group}
    ExecStart=/usr/local/bin/snmp_exporter \\
      --config.file=/etc/snmp_exporter/snmp.yml \\
      --web.listen-address=:#{exporter_port}
    Restart=on-failure
    RestartSec=5s

    # Hardening
    NoNewPrivileges=yes
    ProtectSystem=strict
    ProtectHome=yes
    PrivateTmp=yes
    PrivateDevices=yes
    ProtectHostname=yes
    ProtectClock=yes
    ProtectKernelTunables=yes
    ProtectKernelModules=yes
    ProtectKernelLogs=yes
    ProtectControlGroups=yes
    RestrictSUIDSGID=yes

    [Install]
    WantedBy=multi-user.target
  UNIT
  action [:create, :enable]
  notifies :restart, 'service[snmp_exporter]', :delayed
  only_if { systemd? }
end

service 'snmp_exporter' do
  action [:enable, :start]
  only_if { systemd? }
end

# Add Prometheus scrape config example
log 'prometheus_scrape_config' do
  message <<~MSG
    Add the following to your Prometheus configuration:

    scrape_configs:
      - job_name: 'snmp'
        static_configs:
          - targets:
            - 192.168.1.1  # SNMP device
        metrics_path: /snmp
        params:
          module: [if_mib]
        relabel_configs:
          - source_labels: [__address__]
            target_label: __param_target
          - source_labels: [__param_target]
            target_label: instance
          - target_label: __address__
            replacement: localhost:#{exporter_port}
  MSG
  level :info
end
