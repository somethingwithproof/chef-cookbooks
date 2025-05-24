# Chef Cookbook Development Container
FROM mcr.microsoft.com/devcontainers/ruby:3.3-bullseye

# Install Chef Workstation and dependencies
RUN curl -L https://omnitruck.chef.io/install.sh | bash -s -- -P chef-workstation -c stable

# Add Chef to PATH
ENV PATH="/opt/chef-workstation/bin:/opt/chef-workstation/embedded/bin:$PATH"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    vim \
    nano \
    htop \
    && rm -rf /var/lib/apt/lists/*

# Set Chef license acceptance
ENV CHEF_LICENSE=accept-silent

# Install common Ruby gems for cookbook development
RUN gem install bundler test-kitchen kitchen-dokken kitchen-inspec inspec

# Create workspace directory
RUN mkdir -p /workspaces/chef-cookbook

# Set working directory
WORKDIR /workspaces/chef-cookbook

# Default command
CMD ["/bin/bash"]