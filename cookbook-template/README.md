# Chef Cookbook Template

[![CI](https://github.com/thomasvincent/chef-cookbook-template/workflows/CI/badge.svg)](https://github.com/thomasvincent/chef-cookbook-template/actions)
[![Chef Cookbook](https://img.shields.io/cookbook/v/cookbook-template.svg)](https://supermarket.chef.io/cookbooks/cookbook-template)

Modern Chef cookbook template with best practices for Chef 18+ development.

## Features

- **Chef 18+ Compatible**: Leverages modern Chef Infra features and patterns
- **Modern Testing**: Comprehensive testing with ChefSpec, InSpec, and Test Kitchen
- **Docker-based Testing**: Fast, consistent testing environments with kitchen-dokken
- **Continuous Integration**: GitHub Actions workflows for automated testing and deployment
- **Dependency Management**: Daily Dependabot updates for security and maintenance
- **Code Quality**: Cookstyle linting and automated code formatting
- **Template Repository**: Ready to use as a GitHub template for new cookbooks

## Modern Setup

### Prerequisites

- Ruby 3.2+
- Chef Workstation 23.0+ or Chef Infra Client 18.0+
- Vagrant and VirtualBox (for integration testing)
- Docker (optional, for dokken-based testing)

### Installation

```bash
# Clone the repository
git clone https://github.com/thomasvincent/chef-cookbook-template.git
cd chef-cookbook-template

# Install dependencies
bundle install
```

### Quick Start

```bash
# Run linting
bundle exec cookstyle

# Run unit tests
bundle exec rspec

# Run integration tests
bundle exec kitchen test
```

## Kitchen Usage

Test Kitchen is configured to use Vagrant by default for integration testing.

### Basic Commands

```bash
# List available test instances
kitchen list

# Create test instance
kitchen create

# Converge (apply cookbook)
kitchen converge

# Run verification tests
kitchen verify

# Full test cycle (create, converge, verify, destroy)
kitchen test

# Destroy test instance
kitchen destroy
```

### Configuration

The `kitchen.yml` file defines the testing configuration:

- **Driver**: Vagrant for local VM-based testing
- **Provisioner**: chef_solo for cookbook convergence
- **Platform**: Ubuntu 22.04 LTS
- **Suite**: Default recipe test suite

### Testing Multiple Platforms

To test on multiple platforms, add additional platforms to `kitchen.yml`:

```yaml
platforms:
  - name: ubuntu-22.04
  - name: ubuntu-24.04
  - name: debian-12
  - name: rockylinux-9
```

## Testing

### Unit Tests (ChefSpec)

Unit tests are located in `spec/unit/recipes/` and use ChefSpec:

```bash
bundle exec rspec
```

### Integration Tests (Test Kitchen)

Integration tests verify the cookbook works on real systems:

```bash
bundle exec kitchen test
```

### Linting (Cookstyle)

Code style and best practices enforcement:

```bash
bundle exec cookstyle
bundle exec cookstyle -a  # Auto-correct issues
```

## Security Tips

### Secrets Management

- **Never commit secrets**: Use `.gitignore` to exclude sensitive files
- **Use encrypted data bags**: Store secrets in encrypted data bags
- **Chef Vault**: Consider using Chef Vault for secret management
- **Environment variables**: Pass secrets via environment variables in CI/CD

### Code Security

- **Regularly update dependencies**: Run `bundle update` regularly
- **Enable Dependabot**: Automated security updates for dependencies
- **Run security scans**: Use `bundle audit` to check for vulnerabilities
- **Review third-party cookbooks**: Audit dependencies before use

### Infrastructure Security

- **Principle of least privilege**: Minimize permissions in recipes
- **Validate inputs**: Always validate attribute inputs
- **Use HTTPS**: Ensure all remote resources use HTTPS
- **Keep Chef updated**: Use the latest stable Chef version

### Recommended Tools

```bash
# Check for vulnerable gems
bundle audit check --update

# Scan cookbook for security issues
bundle exec cookstyle --only Security

# Verify cookbook signatures
knife cookbook verify cookbook-template
```

## Platform Support

This cookbook supports the following platforms:

- **Ubuntu**: 22.04, 24.04 LTS
- **Debian**: 12 (Bookworm)
- **Rocky Linux**: 9
- **Amazon Linux**: 2023

## Usage

### Basic Usage

Include the cookbook in your run list:

```ruby
include_recipe 'chef-cookbook-template::default'
```

## Development

### Code Quality

This cookbook enforces high code quality standards:

- **Cookstyle**: Ruby and Chef-specific linting
- **ChefSpec**: Comprehensive unit test coverage
- **InSpec**: Integration testing with real systems
- **Unified Mode**: All resources use unified mode for better performance

### Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for your changes
5. Ensure all tests pass (`bundle exec rake`)
6. Commit your changes (`git commit -am 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Maintainers

- Thomas Vincent <thomasvincent@gmail.com>
