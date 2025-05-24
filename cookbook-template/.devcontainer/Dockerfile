# Chef Cookbook Development Container
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies including systemd
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    vim \
    nano \
    htop \
    systemd \
    systemd-sysv \
    init \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Ruby 3.3
RUN apt-get update && apt-get install -y \
    ruby \
    ruby-dev \
    ruby-bundler \
    && rm -rf /var/lib/apt/lists/*

# Install Chef Workstation
RUN curl -L https://omnitruck.chef.io/install.sh | bash -s -- -P chef-workstation -c stable

# Add Chef to PATH
ENV PATH="/opt/chef-workstation/bin:/opt/chef-workstation/embedded/bin:$PATH"

# Set Chef license acceptance
ENV CHEF_LICENSE=accept-silent

# Install common Ruby gems for cookbook development
RUN /opt/chef-workstation/embedded/bin/gem install bundler test-kitchen kitchen-docker kitchen-inspec inspec

# Enable systemd
RUN systemctl set-default multi-user.target

# Create workspace directory
RUN mkdir -p /workspaces/chef-cookbook

# Set working directory
WORKDIR /workspaces/chef-cookbook

# Use systemd as init system for Test Kitchen
CMD ["/sbin/init"]