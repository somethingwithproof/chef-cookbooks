#!/bin/bash
set -e

echo "Setting up Chef Cookbook Development Environment..."

# Install Chef Workstation
curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chef-workstation -c stable

# Add Chef to PATH
echo 'export PATH="/opt/chef-workstation/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="/opt/chef-workstation/embedded/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Install Ruby gems
gem install bundler
bundle install --without development

# Install Test Kitchen and dependencies
gem install test-kitchen kitchen-dokken kitchen-inspec

# Set Chef license acceptance
echo 'export CHEF_LICENSE=accept-silent' >> ~/.bashrc

# Install Docker buildx for multi-platform builds
docker buildx install

# Set git configuration
git config --global --add safe.directory /workspaces/chef-cookbook

# Create kitchen configuration if it doesn't exist
if [ ! -f ".kitchen.yml" ] && [ ! -f ".kitchen.dokken.yml" ]; then
    cp .kitchen.dokken.yml .kitchen.yml
fi

echo "Development environment setup complete!"
echo "Available commands:"
echo "  - chef --version"
echo "  - cookstyle --version"
echo "  - kitchen list"
echo "  - kitchen test"
echo "  - bundle exec rspec"