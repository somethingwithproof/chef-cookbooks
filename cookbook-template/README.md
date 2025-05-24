# Chef Cookbook Template

[![CI](https://github.com/thomasvincent/chef-cookbook-template/workflows/CI/badge.svg)](https://github.com/thomasvincent/chef-cookbook-template/actions)
[![Chef Cookbook](https://img.shields.io/cookbook/v/cookbook-template.svg)](https://supermarket.chef.io/cookbooks/cookbook-template)

Modern Chef cookbook template with best practices for Chef 19+ development.

## Features

- **Chef 18+ Compatible**: Leverages modern Chef Infra features and patterns
- **Modern Testing**: Comprehensive testing with ChefSpec, InSpec, and Test Kitchen
- **Docker-based Testing**: Fast, consistent testing environments with kitchen-dokken
- **Continuous Integration**: GitHub Actions workflows for automated testing and deployment
- **Dependency Management**: Daily Dependabot updates for security and maintenance
- **Code Quality**: Cookstyle linting and automated code formatting
- **Template Repository**: Ready to use as a GitHub template for new cookbooks

## Prerequisites

- **Docker** for devcontainer development
- **VS Code** with Dev Containers extension (recommended)
- Alternative: **Chef Workstation** 23.10.1040+ for native development

## Quick Start

### 🐳 Devcontainer Development (Recommended)

1. **Clone the repository**: `git clone <your-cookbook-repo>`
2. **Open in VS Code**: Use "Dev Containers: Open Folder in Container"
3. **Wait for setup**: Container will automatically install dependencies
4. **Start developing**: All tools pre-configured and ready

```bash
# Inside devcontainer - everything works out of the box
cookstyle .                     # Linting
bundle exec rspec               # Unit tests  
kitchen test                    # Integration tests (uses devcontainer)
```

### 🏠 Native Development

```bash
# Install dependencies
bundle install

# Run all tests
bundle exec rake

# Run specific test suites
bundle exec cookstyle           # Linting
bundle exec rspec               # Unit tests
KITCHEN_LOCAL_YAML=.kitchen.dokken.yml kitchen test  # Integration tests
```

## Testing

This template provides two testing environments:

### 🐳 Devcontainer Testing (Default)
Uses the same environment as development for consistency:
```bash
# Default Test Kitchen configuration uses devcontainer
kitchen test                    # Uses devcontainer image
kitchen list                    # Shows devcontainer platforms
```

### ⚡ CI/CD Testing (Fast)
Uses dokken driver for faster CI execution:
```bash
# For CI/CD or when speed is critical
KITCHEN_LOCAL_YAML=.kitchen.dokken.yml kitchen test
```

### Unit Tests (ChefSpec)
Fast, isolated tests for cookbook logic:
```bash
bundle exec rspec
```

### Linting (Cookstyle)
Code quality and style enforcement:
```bash
bundle exec cookstyle
```

### Testing Environments
- **Local Development**: devcontainer (consistent with dev environment)
- **CI/CD Pipeline**: dokken (optimized for speed)
- **Both support**: Multi-platform testing with same test suites

## Platform Support

This cookbook supports the following platforms:

- **Ubuntu**: 22.04, 24.04 LTS
- **Debian**: 12 (Bookworm)
- **Rocky Linux**: 9
- **Amazon Linux**: 2023

## Resources

### `cookbook_template_example`

Example custom resource demonstrating modern patterns:

```ruby
cookbook_template_example 'my_service' do
  port 8080
  enabled true
  action :create
end
```

#### Properties

- `port` (Integer) - Service port number (default: 8080)
- `enabled` (Boolean) - Whether service should be enabled (default: true)
- `config_template` (String) - Template file name (default: 'service.conf.erb')

#### Actions

- `:create` - Install and configure the service (default)
- `:remove` - Remove the service

## Attributes

| Attribute | Default | Description |
|-----------|---------|-------------|
| `['cookbook_template']['service']['port']` | `8080` | Default service port |
| `['cookbook_template']['service']['enabled']` | `true` | Enable service by default |
| `['cookbook_template']['package']['name']` | Platform-specific | Package name to install |

## Usage

### Basic Usage

Include the cookbook in your run list:

```ruby
include_recipe 'cookbook-template::default'
```

### Advanced Usage

Use the custom resource directly:

```ruby
cookbook_template_example 'web_service' do
  port 3000
  enabled true
  config_template 'custom.conf.erb'
  action :create
end
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

### Release Process

This cookbook uses automated releases:

1. Update version in `metadata.rb`
2. Update `CHANGELOG.md`
3. Create a git tag: `git tag v1.0.0`
4. Push tag: `git push origin v1.0.0`
5. GitHub Actions will automatically release to Supermarket

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