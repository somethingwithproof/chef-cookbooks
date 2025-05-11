# tcp_wrappers Cookbook

[![Build Status](https://github.com/thomasvincent/chef-tcp-wrappers/actions/workflows/ci.yml/badge.svg)](https://github.com/thomasvincent/chef-tcp-wrappers/actions/workflows/ci.yml) [![Chef cookbook](https://img.shields.io/badge/Cookbook%20Version-0.3.0-blue.svg)](https://github.com/thomasvincent/chef-tcp-wrappers)

A Chef Infra cookbook for managing TCP Wrappers configurations on modern Linux distributions.

The Chef `tcp_wrappers` cookbook installs the `tcp_wrappers` package and configures the `/etc/hosts.deny` or `/etc/hosts.allow` file.

It also exposes a custom resource for adding and managing tcp_wrappers rules.

## Requirements

### Platforms

- Ubuntu 20.04+
- Debian 11+
- RHEL 8+
- AlmaLinux 8+
- Rocky Linux 8+
- Amazon Linux 2+
- Fedora 36+

### Chef

- Chef 16.0+

### Cookbooks

- None

## Attributes

- `node['authorization']['tcp_wrappers']['hosts']` - hosts to enable tcp_wrappers access (default: `[]`)
- `node['authorization']['tcp_wrappers']['daemons']` - daemons to control via tcp_wrappers by default (default: `[]`)
- `node['authorization']['tcp_wrappers']['options']` - default options to pass via tcp_wrappers by default (default: `[]`)
- `node['authorization']['tcp_wrappers']['hosts_allow_defaults']` - default entries in hosts.allow (default: `[]`)
- `node['authorization']['tcp_wrappers']['prefix']` - installation prefix (default: `/etc`)
- `node['authorization']['tcp_wrappers']['include_wrappers_d']` - whether to include wrappers.d directory (default: `true`)
- `node['authorization']['tcp_wrappers']['package']` - package name, auto-detected based on platform

## Usage

### Basic Usage

Include the default recipe in your run list to install the TCP Wrappers package and create the basic directory structure:

```ruby
include_recipe 'tcp_wrappers'
```

### Custom Resource

Use the `tcp_wrappers` resource to configure TCP Wrappers rules:

```ruby
tcp_wrappers 'sshd' do
  daemon 'sshd'
  hosts ['192.168.1.0/24', '10.0.0.0/8']
  commands ['spawn /bin/echo `/bin/date` access granted >> /var/log/sshd.log']
  action :install
end
```

The resource supports the following properties:

- `daemon` - The daemon to configure (e.g., sshd, ftpd)
- `hosts` - Array of hosts to allow or deny
- `commands` - Array of commands to execute when the rule matches
- `template` - Optional template to use instead of the default
- `variables` - Template variables when using a custom template

## Testing

This cookbook uses Test Kitchen for testing, with Docker as the preferred driver. The testing structure includes:

1. **Unit Tests**: ChefSpec for testing individual cookbook components
2. **Style Tests**: Cookstyle for ensuring style guidelines are followed
3. **Integration Tests**: Test Kitchen with InSpec for verifying cookbook behavior

### Prerequisites

- Ruby 2.7 or later
- Bundler
- Docker

### Running Tests

We provide a Makefile to simplify test execution:

```bash
# Install dependencies
make install

# Run all tests across all platforms
make test-all

# Run tests for specific platforms
make test-ubuntu
make test-debian
make test-almalinux

# Run specific test suites
make test-default
make test-create
make test-remove

# Run style/lint checks
make lint

# Clean up test artifacts
make clean
```

### CI Integration

The cookbook includes configuration for GitHub Actions to automatically run tests on pull requests and commits to the main branch.

### Docker-based Testing with verify.sh

For quick and consistent testing across environments, use the included `verify.sh` script which runs tests in Docker:

```bash
# Run all tests (lint, unit, integration)
./verify.sh

# Run only linting checks
./verify.sh --lint

# Run only unit tests
./verify.sh --unit

# Run only integration tests
./verify.sh --integration

# Display help
./verify.sh --help
```

This script automatically uses the official Chef Workstation Docker image to ensure consistent testing across different environments, without requiring local Ruby or Chef installation.

### Quick Docker Validation

For a quick validation without running the full test suite:

```bash
docker run --rm -v $(pwd):/cookbook -w /cookbook ubuntu:22.04 \
  bash -c "apt-get update && \
  apt-get install -y apt-transport-https lsb-release procps net-tools && \
  mkdir -p /etc/wrappers.d && \
  touch /etc/hosts.allow && \
  touch /etc/hosts.deny && \
  echo 'Directory structure created successfully.'"
```

## License & Authors

**Author:** Thomas Vincent (thomasvincent@gmail.com)

**Copyright:** 2017-2025, Thomas Vincent

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```