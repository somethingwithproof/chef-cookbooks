#!/bin/bash
set -e

echo "Building Docker test image..."
docker build -t chef-test -f- . <<EOF
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl ca-certificates gnupg &&\
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://packages.chef.io/chef.asc | gpg --dearmor -o /etc/apt/keyrings/chef.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/chef.gpg] https://packages.chef.io/repos/apt/stable jammy main" > /etc/apt/sources.list.d/chef-stable.list && \
    apt-get update && \
    apt-get install -y chef && \
    apt-get clean

WORKDIR /cookbook
EOF

echo "Running Chef test in Docker..."
docker run --rm -v $(pwd):/cookbook chef-test bash -c "export CHEF_LICENSE=accept-no-persist && cd /cookbook && chef-client -z -c /cookbook/client.rb -o 'recipe[tcp_wrappers::default]' -l info"

echo "Verification complete!"