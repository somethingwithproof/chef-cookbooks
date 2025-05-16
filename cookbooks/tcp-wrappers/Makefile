.PHONY: test-all test-ubuntu test-debian test-almalinux test-default test-create test-remove lint clean install

# Install dependencies
install:
	bundle install

# Run all Test Kitchen tests
test-all: install
	bundle exec kitchen test

# Test specific platforms
test-ubuntu: install
	bundle exec kitchen test default-ubuntu-2204

test-debian: install
	bundle exec kitchen test default-debian-11

test-almalinux: install
	bundle exec kitchen test default-almalinux-9

# Test specific suites
test-default: install
	bundle exec kitchen test default

test-create: install
	bundle exec kitchen test create

test-remove: install
	bundle exec kitchen test remove

# Run cookstyle linting for Chef 18+ compatibility
lint: install
	bundle exec cookstyle --chef-version 18.0

# Clean up
clean:
	bundle exec kitchen destroy
	rm -rf .kitchen
	rm -rf Gemfile.lock

# Docker testing
docker-test:
	docker run --rm -v "$(PWD):/cookbook" -w /cookbook chef/chefworkstation:latest bash -c "CHEF_LICENSE=accept-no-persist kitchen test default-ubuntu-2204"

# Help
help:
	@echo "Chef 18+ TCP Wrappers Cookbook"
	@echo
	@echo "Available targets:"
	@echo "  install        - Install required gems"
	@echo "  test-all       - Run all Test Kitchen tests"
	@echo "  test-ubuntu    - Run tests for Ubuntu 22.04"
	@echo "  test-debian    - Run tests for Debian 11"
	@echo "  test-almalinux - Run tests for AlmaLinux 9"
	@echo "  test-default   - Run default suite tests"
	@echo "  test-create    - Run create suite tests"
	@echo "  test-remove    - Run remove suite tests"
	@echo "  lint           - Run cookstyle linting for Chef 18+"
	@echo "  docker-test    - Run tests in Docker container"
	@echo "  clean          - Clean up test artifacts"