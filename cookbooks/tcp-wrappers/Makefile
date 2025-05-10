.PHONY: test-all test-ubuntu test-debian test-almalinux test-default test-create test-remove lint clean install

# Install dependencies
install:
	bundle install

# Run all Test Kitchen tests
test-all: install
	bundle exec kitchen test

# Run tests for Ubuntu 22.04
test-ubuntu: install
	bundle exec kitchen test default-ubuntu-2204

# Run tests for Debian 11
test-debian: install
	bundle exec kitchen test default-debian-11

# Run tests for AlmaLinux 9
test-almalinux: install
	bundle exec kitchen test default-almalinux-9

# Run default suite tests
test-default: install
	bundle exec kitchen test default

# Run create suite tests
test-create: install
	bundle exec kitchen test create

# Run remove suite tests
test-remove: install
	bundle exec kitchen test remove

# Run cookstyle linting
lint: install
	bundle exec cookstyle

# Clean up
clean:
	bundle exec kitchen destroy
	rm -rf .kitchen
	rm -rf Gemfile.lock

# Help
help:
	@echo "Available targets:"
	@echo "  install        - Install required gems"
	@echo "  test-all       - Run all Test Kitchen tests"
	@echo "  test-ubuntu    - Run tests for Ubuntu 22.04"
	@echo "  test-debian    - Run tests for Debian 11"
	@echo "  test-almalinux - Run tests for AlmaLinux 9"
	@echo "  test-default   - Run default suite tests"
	@echo "  test-create    - Run create suite tests"
	@echo "  test-remove    - Run remove suite tests"
	@echo "  lint           - Run cookstyle linting"
	@echo "  clean          - Clean up test artifacts"