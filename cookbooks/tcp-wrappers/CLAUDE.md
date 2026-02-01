# chef-tcp-wrappers

## Purpose
DEPRECATED Chef cookbook for managing TCP Wrappers (`/etc/hosts.allow`, `/etc/hosts.deny`). Use firewalld or nftables instead.

## Stack
- Chef 18+ / Ruby
- ChefSpec (unit), InSpec (integration), Test Kitchen (kitchen-dokken)

## Build / Test
```bash
bundle install
bundle exec cookstyle          # Lint
bundle exec rspec              # ChefSpec unit tests
bundle exec kitchen test       # Integration tests (Docker/Dokken)
```

## Standards
- Unified mode for custom resources
- Guard properties on all `execute` resources
- ChefSpec tests in `spec/`, InSpec tests in `test/`
- Cookstyle clean
- Custom resources in `resources/`
