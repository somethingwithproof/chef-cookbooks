# HBase Cookbook Changelog

This file tracks the changes in the HBase cookbook over time.

## 1.2.0 (2026-04-10)

- Normalize the supported OS matrix to Ubuntu 20.04+, Debian 11+, RHEL/CentOS/Rocky/AlmaLinux/Oracle 8+, and Amazon Linux 2023+
- Fix duplicate `action :run` and inverted `not_if` guard in the `java` recipe
- Replace `Mixlib::ShellOut` with the built-in `shell_out` helper
- Remove duplicate `/etc/security/limits.d/hbase.conf` declaration between `user` and `limits` recipes
- Rewire `hbase-env.sh` template to read its values from resource variables instead of node attributes
- Honor `log_dir`/`log_level` variables in `log4j2.properties`
- Make the `hbase_service` custom resource use a `pid_dir` property rather than a hardcoded path and keep the systemd unit and `service` resource names in sync
- Add ChefSpec coverage for `hbase::java`, `hbase::limits`, `hbase::thrift`, `hbase::rest`, and `hbase::backup_master`, plus platform-matrix smoke tests for `hbase::default`
- Correct the default InSpec suite to match the ark-managed `/opt/hbase` symlink layout

## 1.1.0 (2024-05-09)

- Enhanced Java compatibility for HBase
- Added dedicated java recipe for platform-specific Java installation
- Updated to support Java 8, 11, and 17 based on HBase compatibility
- Improved Java home auto-detection based on OS platform
- Updated integration tests for Java compatibility
- Removed dependency on the java cookbook for more direct control
- Enhanced documentation for Java version support
- Added Test Kitchen tests for Java compatibility
- Updated to HBase 2.5.11 (latest stable version)
- Updated Hadoop version to 3.3.5

## 1.0.0 (2023-05-10)

- Initial release with modern Chef 17+ support
- Comprehensive implementation of HBase with Docker testing
- Support for distributed and standalone deployments
- Custom resources for service and configuration management
- GitHub Actions CI integration
- Support for latest platforms: Ubuntu 20.04/22.04, Debian 11+, AlmaLinux/RHEL 8/9, Amazon Linux 2, Fedora 36+
- Enhanced security features including Kerberos integration
- REST and Thrift API support
- Metrics collection capabilities (Prometheus, Graphite)
- Performance tuning options
- Advanced configuration options