# SNMP Cookbook

[![CI](https://github.com/thomasvincent/chef-snmp-cookbook/actions/workflows/ci.yml/badge.svg)](https://github.com/thomasvincent/chef-snmp-cookbook/actions/workflows/ci.yml)

This cookbook installs and configures the SNMP (Simple Network Management Protocol) service on supported platforms.

## Requirements

- Chef Infra Client 18.0 or later
- Docker (for testing with kitchen-dokken)

## Platforms

The following platforms are supported and tested:

- Ubuntu 22.04, 20.04
- CentOS Stream 9
- AlmaLinux 9
- Debian 11
- RHEL 9
- Fedora 36+
- Amazon Linux 2

Other platforms may also be supported as long as they're not EOL, but they have not been tested.

## Resources

### snmp_install

The `snmp_install` resource installs and configures the SNMP service.

#### Properties

- `community` - SNMP community string (default: 'public')
- `node['snmp']['trap']['community']` - SNMP trap community string (default: 'public')
- `trap_addresses` - Array of trap addresses (default: [])
- `trap_port` - SNMP trap port (default: 162)
- `groups` - Hash of SNMP groups (default: {})
- `sec_name` - Hash of security names (default: { notConfigUser: %w(default) })
- `sec_name6` - Hash of IPv6 security names (default: { notConfigUser: %w(default) })

#### Examples

```ruby
snmp_install 'default' do
  community 'private'
  groups { 
    v1: { notConfigGroup: %w(notConfigUser) },
    v2c: { notConfigGroup: %w(notConfigUser) }
  }
end
```

### snmp_trapd

The `snmp_trapd` resource installs and configures the SNMP trap daemon.

#### Properties

- `trap_community` - SNMP trap community string (default: 'public')
- `trap_addresses` - Array of trap addresses (default: [])
- `trap_port` - SNMP trap port (default: 162)
- `trap_service` - SNMP trap service name (platform-dependent)

#### Examples

```ruby
snmp_trapd 'default' do
  trap_community 'private'
  trap_addresses ['192.168.1.1']
  trap_port 162
end
```

## Recipes

### default

The `default` recipe uses the `snmp_install` resource to install and configure the SNMP service.

### snmptrapd

The `snmptrapd` recipe uses the `snmp_trapd` resource to install and configure the SNMP trap daemon.

## Development

### Chef Version Compatibility

This cookbook requires Chef Infra Client 18.0 or later and is tested against:
- Chef Infra Client 18.x
- Chef Infra Client 19.x

The cookbook is designed following Chef Infra best practices and uses current idioms like:
- Custom resources with unified_mode
- Property validation
- Helper methods for platform-specific logic

### Dependency Versions

This cookbook uses only currently supported versions of its dependencies:
- Chef Infra Client 18.x/19.x
- InSpec 5.x
- Test Kitchen 3.5+
- kitchen-dokken 2.x (preferred over kitchen-docker)

### Pre-commit Hooks

This cookbook uses pre-commit hooks to ensure code quality. To set up the hooks, run:

```shell
./scripts/setup-hooks.sh
```

This will install a pre-commit hook that runs cookstyle on your staged Ruby files before committing.

## Testing

This cookbook uses Test Kitchen with kitchen-dokken for integration testing. To run the tests:

```shell
kitchen test
```

### Linting

To run linting manually:

```shell
cookstyle
```

## License

This cookbook is licensed under the Apache License, Version 2.0. See the [LICENSE](LICENSE) file for details.