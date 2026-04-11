#
# Cookbook:: hbase
# Recipe:: java
#
# Copyright:: 2023 Thomas Vincent
#
# Licensed under the Apache License, Version 2.0

jdk_version = node['hbase']['java']['version']

# Derive JAVA_HOME when not explicitly overridden. The layout differs across
# package managers, so keep the branches explicit rather than guessing.
if node['hbase']['java_home'].nil?
  node.default['hbase']['java_home'] =
    case node['platform_family']
    when 'debian'
      "/usr/lib/jvm/java-#{jdk_version}-openjdk-amd64"
    when 'rhel', 'amazon'
      "/usr/lib/jvm/java-#{jdk_version}-openjdk"
    else
      "/usr/lib/jvm/java-#{jdk_version}-openjdk"
    end
end

case node['platform_family']
when 'debian'
  package "openjdk-#{jdk_version}-jdk"
when 'rhel', 'amazon'
  package "java-#{jdk_version}-openjdk-devel"
else
  Chef::Log.warn("Unsupported platform family for Java installation: #{node['platform_family']}. Install Java manually.")
end

# Fail fast at converge time if the JDK isn't callable. shell_out is built into
# Chef 18, so Mixlib is unnecessary here.
ruby_block 'verify_java_installation' do
  block do
    result = shell_out('java -version')
    raise "Java installation failed: #{result.stderr}" if result.error?
    Chef::Log.info("Java installation verified: #{result.stderr.lines.first}")
  end
  action :run
end

file '/etc/profile.d/java_home.sh' do
  content "export JAVA_HOME=#{node['hbase']['java_home']}\n"
  mode '0755'
  action :create
end
