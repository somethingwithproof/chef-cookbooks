# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-06-22

### Changed

- **BREAKING**: Updated to Chef 18.7.10+ with Ruby 3.1 support
- **BREAKING**: Removed all external cookbook dependencies - using Chef 18 built-in resources only
- Replaced Berksfile with Policyfile for dependency management
- Switched from dokken to Docker driver for Test Kitchen
- Updated all platforms to current non-EOL versions (Ubuntu 22.04/24.04, Debian 12, CentOS 9, Rocky 9)
- Modernized testing stack with Docker-based Test Kitchen
- Implemented comprehensive InSpec integration tests
- Enhanced .rubocop.yml with full Chef cop coverage
- Improved resource implementation following Chef 18.7 best practices

### Added

- Docker-based Test Kitchen configuration
- InSpec integration test profiles
- Comprehensive .gitignore for modern Chef development
- Full cookstyle/rubocop configuration for Chef 18.7

### Removed

- Berksfile and Berksfile.lock (replaced by Policyfile)
- Legacy dokken configuration
- Support for EOL platforms
- All external cookbook dependencies

### Fixed

- All RSpec test failures
- Ruby 3.1 compatibility throughout
- CI/CD pipeline for modern Chef testing

## [0.4.0] - 2024-05-01

### Added

- Initial release of r-language cookbook
- Support for package and source installation methods
- Custom resource for R package management
- Multi-platform support (Ubuntu, Debian, RHEL, SUSE, etc.)
- Comprehensive test coverage with ChefSpec and InSpec
