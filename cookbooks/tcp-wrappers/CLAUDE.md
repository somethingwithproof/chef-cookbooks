# chef-tcp-wrappers

## Purpose
Chef cookbook for managing TCP Wrappers (`/etc/hosts.allow`, `/etc/hosts.deny`) with custom resources for rule management.

## Stack
- Chef 16+ / Ruby
- ChefSpec (unit), InSpec (integration), Test Kitchen
- Makefile for common tasks
- Docker for testing

## Build / Test
```bash
bundle install
bundle exec rspec              # ChefSpec unit tests
bundle exec kitchen test       # Integration tests (Docker)
make test                      # Full test suite
make lint                      # Lint
```

## Standards
- Unified mode for custom resources
- Guard properties on all `execute` resources
- ChefSpec tests in `spec/`, InSpec tests in `test/`
- Cookstyle clean
- Custom resources in `resources/`
