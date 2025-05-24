# Chef Cookbook Development Container

This devcontainer provides a complete Chef cookbook development environment with all necessary tools and dependencies pre-installed.

## Features

- **Ruby 3.3.0 LTS** - Latest Ruby LTS version
- **Chef Workstation** - Complete Chef development toolkit
- **Test Kitchen** - Infrastructure testing framework
- **Docker-in-Docker** - For running kitchen-dokken tests
- **VS Code Extensions** - Chef, Ruby, YAML, and JSON support

## Getting Started

1. **Open in VS Code**: Use the "Dev Containers" extension to open this project in a container
2. **Wait for Setup**: The container will automatically install all dependencies
3. **Start Developing**: Run Chef cookbook commands immediately

## Available Commands

### Development
```bash
# Lint your cookbook
cookstyle .

# Run unit tests
bundle exec rspec

# Check cookbook syntax
chef exec foodcritic .
```

### Testing
```bash
# List available test suites
kitchen list

# Run integration tests (single platform)
kitchen test default-ubuntu-2204

# Run all integration tests
kitchen test

# Destroy test instances
kitchen destroy
```

### Platform Testing

The devcontainer is configured to test against supported platforms:
- Ubuntu 22.04, 24.04 LTS
- Debian 12 (Bookworm)
- Rocky Linux 9
- Amazon Linux 2023

## Environment Variables

- `CHEF_LICENSE=accept-silent` - Automatically accepts Chef license
- `KITCHEN_LOCAL_YAML=.kitchen.dokken.yml` - Uses Docker for testing

## Docker Support

The container includes Docker-in-Docker support for:
- Running kitchen-dokken tests
- Building and testing cookbook containers
- Multi-platform cookbook testing

## Troubleshooting

### Kitchen Tests Not Working
```bash
# Ensure Docker is running
docker info

# Check kitchen configuration
kitchen diagnose

# Verify platform availability
docker images | grep dokken
```

### Gem Issues
```bash
# Reinstall gems
bundle install

# Update gems
bundle update
```

## VS Code Extensions

Pre-installed extensions include:
- Chef Language Support
- Ruby LSP
- YAML/JSON validation
- Git integration