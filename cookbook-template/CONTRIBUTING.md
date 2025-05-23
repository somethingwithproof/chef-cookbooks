# Contributing to Chef Cookbook Template

We welcome contributions to this cookbook template! This document provides guidelines for contributing.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues as you might find that the problem has already been reported. When creating a bug report, please include as many details as possible:

- Use a clear and descriptive title
- Describe the exact steps to reproduce the problem
- Provide specific examples and sample code
- Include Chef version, platform, and cookbook version
- Include relevant log output

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

- A clear and descriptive title
- A detailed description of the proposed enhancement
- Explanation of why this enhancement would be useful
- Examples of how the enhancement would be used

### Pull Requests

1. Fork the repository
2. Create a feature branch from `main`
3. Make your changes
4. Add tests for your changes
5. Ensure all tests pass
6. Update documentation if needed
7. Submit a pull request

## Development Setup

### Prerequisites

- Ruby 3.2.0+
- Chef Workstation 23.10+
- Docker (for integration testing)
- Git

### Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/chef-cookbook-template.git
cd chef-cookbook-template

# Install dependencies
bundle install

# Run tests
bundle exec rake
```

## Testing

### Unit Tests

Unit tests use ChefSpec and should cover all resources and recipes:

```bash
bundle exec rspec
```

### Integration Tests

Integration tests use Test Kitchen with Docker:

```bash
# Test all platforms
bundle exec kitchen test

# Test specific platform
bundle exec kitchen test default-ubuntu-2004

# Test with Vagrant (if preferred)
KITCHEN_YAML=.kitchen.yml bundle exec kitchen test
```

### Linting

Code must pass Cookstyle linting:

```bash
bundle exec cookstyle
```

## Coding Standards

### Chef Best Practices

- Use unified mode for all custom resources (`unified_mode true`)
- Follow Chef 19+ patterns and conventions
- Use proper resource naming conventions
- Include comprehensive property validation
- Implement both `:create` and `:remove` actions where applicable

### Ruby Style

- Follow the Ruby Style Guide
- Use frozen string literals (`# frozen_string_literal: true`)
- Prefer explicit returns in methods
- Use meaningful variable and method names

### Documentation

- Include clear resource documentation
- Update README.md for new features
- Add examples for new functionality
- Include platform support information

### Testing Requirements

- All new code must have unit tests
- Integration tests required for new resources
- Maintain or improve test coverage
- Test on multiple platforms when possible

## Resource Development Guidelines

### Custom Resources

When creating custom resources:

```ruby
# frozen_string_literal: true

unified_mode true

provides :my_resource

property :name, String, name_property: true
property :enabled, [true, false], default: true

action :create do
  # Implementation
end

action :remove do
  # Implementation  
end
```

### Properties

- Use appropriate data types
- Include validation callbacks where needed
- Provide sensible defaults
- Use `name_property: true` for the primary identifier
- Use `lazy` evaluation for node attributes

### Actions

- Implement both `:create` and `:remove` actions
- Use descriptive action names
- Include resource notifications where appropriate
- Handle idempotency properly

## Platform Support

### Supported Platforms

We aim to support:
- Ubuntu 20.04, 22.04
- Debian 10, 11
- CentOS 7
- Rocky Linux 8, 9
- Amazon Linux 2
- openSUSE Leap 15

### Platform Testing

- Test on multiple platforms in CI
- Use kitchen-dokken for fast Docker-based testing
- Include platform-specific logic where needed
- Document platform limitations

## Release Process

1. Update version in `metadata.rb`
2. Update `CHANGELOG.md`
3. Create and push git tag
4. GitHub Actions will automatically release to Supermarket

## Getting Help

- Open an issue for questions
- Check existing documentation
- Review test examples
- Ask in Chef community channels

## Attribution

Contributors will be acknowledged in the CHANGELOG and GitHub contributors list.

Thank you for contributing!