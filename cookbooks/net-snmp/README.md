# chef-net-snmp-cookbook

A Chef cookbook for installing and configuring Net-SNMP with SNMPv3 support.

## Requirements

- Chef Infra Client >= 18.0
- Platforms:
  - Ubuntu 20.04+
  - Debian 11+
  - CentOS/RHEL 8+
  - Rocky Linux 8+
  - AlmaLinux 8+
  - Amazon Linux 2+

## Usage

Add `recipe[net-snmp::default]` to your run list.

## Attributes

| Attribute | Default | Description |
|-----------|---------|-------------|
| `node['net-snmp']['snmpv3']['enabled']` | `false` | Enable SNMPv3 configuration |
| `node['net-snmp']['snmpv3']['users']` | `[]` | Array of SNMPv3 user configurations |

## SNMPv3 Setup

SNMPv3 provides enhanced security through authentication and encryption. To enable SNMPv3:

### Basic Configuration

```ruby
default['net-snmp']['snmpv3']['enabled'] = true
default['net-snmp']['snmpv3']['users'] = [
  {
    'username' => 'monitoring_user',
    'auth_protocol' => 'SHA',
    'auth_password' => 'your_auth_password_min_8_chars',
    'priv_protocol' => 'AES',
    'priv_password' => 'your_priv_password_min_8_chars',
  },
]
```

### Security Levels

SNMPv3 supports three security levels:

1. **noAuthNoPriv** - No authentication, no encryption (not recommended)
2. **authNoPriv** - Authentication only (SHA/MD5)
3. **authPriv** - Authentication and encryption (SHA+AES recommended)

### Recommended Settings

For production environments, always use:

- **Authentication Protocol**: SHA (SHA-256 or SHA-512 preferred if available)
- **Privacy Protocol**: AES (AES-256 preferred if available)
- **Passwords**: Minimum 12 characters, use secrets management

### Testing SNMPv3

```bash
# Test SNMPv3 connection
snmpwalk -v3 -u monitoring_user -l authPriv \
  -a SHA -A 'your_auth_password' \
  -x AES -X 'your_priv_password' \
  localhost .1.3.6.1.2.1.1
```

### Security Best Practices

1. **Never commit passwords** - Use Chef encrypted data bags or external secrets management
2. **Rotate credentials regularly** - Implement credential rotation policies
3. **Restrict network access** - Use firewall rules to limit SNMP access
4. **Monitor access logs** - Enable and review SNMP access logging
5. **Disable SNMPv1/v2c** - This cookbook disables legacy protocols when SNMPv3 is enabled

## Testing

### Unit Tests (ChefSpec)

```bash
bundle exec rspec
```

### Integration Tests (Test Kitchen)

```bash
# Run all tests
bundle exec kitchen test

# Run SNMPv3 specific tests
bundle exec kitchen test snmpv3
```

## License

Apache-2.0

## Author

Thomas Vincent
