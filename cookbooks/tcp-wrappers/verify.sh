#!/bin/bash
set -e

# Function to display help message
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Run tests for TCP Wrappers cookbook in Docker"
  echo
  echo "Options:"
  echo "  -l, --lint         Run cookstyle linting"
  echo "  -u, --unit         Run ChefSpec unit tests"
  echo "  -i, --integration  Run Test Kitchen integration tests"
  echo "  -a, --all          Run all tests (default)"
  echo "  -h, --help         Display this help message"
}

# Parse arguments
run_lint=false
run_unit=false
run_integration=false

if [[ $# -eq 0 ]]; then
  run_lint=true
  run_unit=true
  run_integration=true
else
  while [[ $# -gt 0 ]]; do
    case $1 in
      -l|--lint)
        run_lint=true
        shift
        ;;
      -u|--unit)
        run_unit=true
        shift
        ;;
      -i|--integration)
        run_integration=true
        shift
        ;;
      -a|--all)
        run_lint=true
        run_unit=true
        run_integration=true
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown option: $1"
        usage
        exit 1
        ;;
    esac
  done
fi

echo "Using Chef Workstation Docker image for testing..."

if [ "$run_lint" = true ]; then
  echo "==> Running cookstyle linting..."
  docker run --rm -v "$(pwd):/cookbook" -w /cookbook chef/chefworkstation:latest bash -c "cookstyle --fail-level E"
  echo "Linting complete!"
fi

if [ "$run_unit" = true ]; then
  echo "==> Running ChefSpec unit tests..."
  docker run --rm -v "$(pwd):/cookbook" -w /cookbook chef/chefworkstation:latest bash -c "bundle install && bundle exec rspec"
  echo "Unit tests complete!"
fi

if [ "$run_integration" = true ]; then
  echo "==> Running Test Kitchen integration tests..."
  docker run --rm -v "$(pwd):/cookbook" -v /var/run/docker.sock:/var/run/docker.sock -w /cookbook chef/chefworkstation:latest bash -c "KITCHEN_YAML=kitchen.yml CHEF_LICENSE=accept-no-persist bundle install && bundle exec kitchen test default-ubuntu-2204"
  echo "Integration tests complete!"
fi

echo "Verification complete!"