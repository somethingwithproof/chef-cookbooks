# chef-net-snmp-cookbook

Chef cookbook for installing and configuring Net-SNMP with SNMPv3 support.

[![CI](https://github.com/thomasvincent/chef-net-snmp-cookbook/actions/workflows/ci.yml/badge.svg)](https://github.com/thomasvincent/chef-net-snmp-cookbook/actions/workflows/ci.yml)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Overview

This cookbook provides comprehensive SNMP daemon management including:

- Net-SNMP package installation and service management
- SNMPv2c community string configuration (for legacy systems)
- **SNMPv3 user management with authentication and encryption** (recommended)
- Custom resources for declarative configuration
- Disk, load, and process monitoring
- SELinux support for RHEL-based systems

## Security Notice

**SNMPv1/v2c use cleartext community strings and are vulnerable to sniffing attacks.**

For production environments, use SNMPv3 with:
- Strong authentication (SHA-256 or better)
- Encryption (AES-256)
- Unique credentials per system

## Requirements

- **Chef**: >= 19.0
- **Platforms**: Ubuntu 20.04+, Debian 11+, CentOS 8+, RHEL 8+, Amazon Linux 2+, Rocky 8+, Alma 8+

## Usage

### Basic Installation

Add to your `Berksfile`:

```ruby
cookbook 'net-snmp', git: 'https://github.com/thomasvincent/chef-net-snmp-cookbook'
```

Include in your recipe or run_list:

```ruby
include_recipe 'net-snmp::default'
```

### SNMPv3 Configuration (Recommended)

```ruby
# In your attributes or recipe
node.default['net_snmp']['v3_users'] = [
  {
    'username' => 'monitoring',
    'auth_protocol' => 'SHA-256',
    'auth_password' => 'YourSecureAuthPassword123!',
    'priv_protocol' => 'AES-256',
    'priv_password' => 'YourSecurePrivPassword456!',
    'security_level' => 'authPriv',
    'access_level' => 'ro',
    'view' => 'systemview'
  }
]

include_recipe 'net-snmp::v3'
```

### Using Custom Resources

#### snmp_config

Configure the SNMP daemon:

```ruby
snmp_config 'main' do
  sys_location 'Data Center 1, Rack 42'
  sys_contact 'ops@example.com'
  listen_address 'udp:161'
  community_strings [
    { community: 'readSecret', access: 'rocommunity', source: '10.0.0.0/8', view: 'systemview' }
  ]
  views [
    { name: 'systemview', type: 'included', oid: '.1.3.6.1.2.1' }
  ]
  disk_monitoring ['/', '/var']
  load_thresholds({ '1min' => 12, '5min' => 10, '15min' => 5 })
  action :create
end
```

#### snmp_user

Create SNMPv3 users:

```ruby
snmp_user 'monitoring' do
  auth_protocol 'SHA-256'
  auth_password 'secure_password_here'
  priv_protocol 'AES-256'
  priv_password 'another_secure_password'
  security_level 'authPriv'
  access_level 'ro'
  view 'systemview'
  action :create
end
```

### Testing SNMPv3 Connection

```bash
# Test authentication and encryption
snmpget -v3 -u monitoring -l authPriv \
  -a SHA-256 -A 'YourAuthPassword' \
  -x AES-256 -X 'YourPrivPassword' \
  localhost sysDescr.0
```

## Attributes

| Attribute | Description | Default |
|-----------|-------------|---------|
| `node['net_snmp']['sys_location']` | System location | `'Unknown'` |
| `node['net_snmp']['sys_contact']` | System contact | `'root@localhost'` |
| `node['net_snmp']['listen_address']` | Listen address | `'udp:161,udp6:[::1]:161'` |
| `node['net_snmp']['community_strings']` | SNMPv2c communities | `[]` |
| `node['net_snmp']['v3_users']` | SNMPv3 user definitions | `[]` |
| `node['net_snmp']['views']` | View definitions | System views |
| `node['net_snmp']['disk_monitoring']` | Disk paths to monitor | `[]` |
| `node['net_snmp']['load_thresholds']` | Load average thresholds | `{ '1min' => 12, ... }` |

## Recipes

| Recipe | Description |
|--------|-------------|
| `default` | Installs Net-SNMP packages and starts service |
| `v3` | Configures SNMPv3 users (includes default) |

## Custom Resources

### snmp_config

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `config_file` | String | `/etc/snmp/snmpd.conf` | Configuration file path |
| `sys_location` | String | `'Unknown'` | SNMP sysLocation |
| `sys_contact` | String | `'root@localhost'` | SNMP sysContact |
| `community_strings` | Array | `[]` | SNMPv2c communities |
| `views` | Array | System views | View definitions |
| `disk_monitoring` | Array | `[]` | Disk paths to monitor |

### snmp_user

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `username` | String | (name) | SNMPv3 username |
| `auth_protocol` | String | `'SHA-256'` | Authentication protocol |
| `auth_password` | String | (required) | Auth password (min 8 chars) |
| `priv_protocol` | String | `'AES-256'` | Privacy protocol |
| `priv_password` | String | auth_password | Privacy password |
| `security_level` | String | `'authPriv'` | Security level |
| `access_level` | String | `'ro'` | Access level (ro/rw) |

## Troubleshooting

### SNMP service won't start

```bash
# Check configuration syntax
snmpd -C -c /etc/snmp/snmpd.conf

# Check logs
journalctl -u snmpd -f
```

### SNMPv3 authentication fails

1. Verify user exists: `cat /var/lib/snmp/snmpd.conf`
2. Check password length (minimum 8 characters)
3. Ensure protocols match between client and server
4. Restart snmpd after user creation

### SELinux blocking SNMP

```bash
# Check for denials
ausearch -m avc -ts recent | grep snmp

# Apply custom policy if needed
semodule -i snmpd_custom.pp
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for your changes
4. Submit a pull request

## License

Apache-2.0

## Author

Thomas Vincent (<thomasvincent@github.com>)
