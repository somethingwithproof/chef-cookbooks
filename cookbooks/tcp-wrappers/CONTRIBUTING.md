# Contributing to TCP Wrappers Cookbook

Thank you for your interest in contributing to this cookbook! This document provides guidelines and instructions for contributing.

## Code of Conduct

This project and everyone participating in it are governed by a code of conduct that promotes respectful and professional interactions. By participating, you agree to uphold this code.

## Pull Request Process

1. Fork the repository and create your branch from `main`.
2. Ensure your changes are tested for Chef 18+ compatibility.
3. Update the documentation and CHANGELOG.md as necessary.
4. The PR must pass all CI checks before it will be reviewed.
5. For major changes, consider opening an issue first to discuss what you would like to change.

## Development Process

1. Install dependencies:
   ```
   bundle install
   ```

2. Run linting tests:
   ```
   bundle exec cookstyle --chef-version 18.0
   ```

3. Run unit tests:
   ```
   bundle exec rspec
   ```

4. Run integration tests:
   ```
   bundle exec kitchen test
   ```

You can also use the Makefile commands for common operations:
```
make lint
make test-ubuntu
make test-all
```

## Testing

- Use ChefSpec for unit tests
- Use Test Kitchen and InSpec for integration tests
- All tests must pass before a PR can be merged

## Versioning

We use [Semantic Versioning](http://semver.org/). For version updates:

- MAJOR: Incompatible changes that require action from users
- MINOR: Backwards-compatible new features
- PATCH: Backwards-compatible bug fixes

## Release Process

1. Update the version in metadata.rb
2. Update CHANGELOG.md with the new version and changes
3. Commit these changes with a message like "Release X.Y.Z"
4. Tag the release with `git tag vX.Y.Z`
5. Push the tag to trigger a release workflow

Thank you for contributing!