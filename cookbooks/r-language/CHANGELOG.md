# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Updated to Chef 18+ with Ruby 3.1 support
- Removed external cookbook dependencies (apt, yum) - using Chef 18 built-in resources
- Modernized testing with fauxhai-ng and minimal Gemfile
- Switched from Berksfile to Policyfile for dependency management
- Updated all platforms to non-EOL versions
- Improved resource implementation following Chef 18 best practices

### Fixed

- Fixed all RSpec test failures
- Fixed Ruby 3.4 compatibility issues
- Updated CI/CD pipeline for modern Chef testing

## [0.4.0] - 2024-05-01

### Added

- Initial release of r-language cookbook
- Support for package and source installation methods
- Custom resource for R package management
- Multi-platform support (Ubuntu, Debian, RHEL, SUSE, etc.)
- Comprehensive test coverage with ChefSpec and InSpec
