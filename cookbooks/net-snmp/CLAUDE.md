# chef-net-snmp-cookbook

## Purpose
Chef cookbook for installing and configuring Net-SNMP with SNMPv3 support, disk/load/process monitoring, and SELinux support.

## Stack
- Chef 18+ / Ruby
- ChefSpec (unit), Test Kitchen with kitchen-dokken (integration)

## Build / Test
```bash
bundle install
bundle exec cookstyle          # Lint
bundle exec rspec              # ChefSpec unit tests
bundle exec kitchen test       # Integration tests (Docker)
```

## Standards
- Unified mode for custom resources
- Guard properties on all `execute` resources
- ChefSpec tests in `spec/`, InSpec tests in `test/`
- Cookstyle clean
- Prefer SNMPv3 with strong auth/encryption in examples
- Custom resources in `resources/`
