# SNMP Cookbook

This cookbook installs and configures the SNMP (Simple Network Management Protocol) service on supported platforms.

## Requirements

- Chef 13.0 or later
- Test Kitchen 2.5 or later
- Vagrant 2.0 or later
- VirtualBox or VMware Workstation/Fusion (for testing)

## Platforms

The following platforms are supported and tested:

- Ubuntu 20.04
- CentOS 8
- Fedora 32
- Windows 2019
- Solaris 11
- AIX 7.2
- macOS 10.15

Other platforms may also be supported, but they have not been tested.

## Recipes

### default

The `default` recipe installs and configures the SNMP service and creates a configuration file based on the `node['snmp']['groups']` attribute.

## Attributes

- `node['snmp']['groups']`: A hash of SNMP groups to configure, with the group name as the key and a hash of attributes as the value. The supported attributes are:
  - `'sec_model'`: The security model for the group (e.g. 'v1', 'v2c', 'usm').
  - `'read_view'`: The read view for the group.

## Tests

This cookbook includes unit tests written with ChefSpec and integration tests written with InSpec.

To run the tests, install the required gems with `bundle install` and then run `kitchen test`.

## License

This cookbook is licensed under the Apache License, Version 2.0. See the [LICENSE](LICENSE) file for details.

