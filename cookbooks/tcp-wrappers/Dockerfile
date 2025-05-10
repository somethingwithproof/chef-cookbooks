FROM ubuntu:22.04

WORKDIR /cookbook

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    sudo \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Chef Workstation
RUN curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chef-workstation -v 23.5.1040

# Set environment variables
ENV CHEF_LICENSE=accept-no-persist
ENV PATH=/opt/chef-workstation/bin:/opt/chef-workstation/embedded/bin:$PATH
ENV LANG=en_US.UTF-8

# Install kitchen-dokken
RUN chef gem install kitchen-dokken

# Copy the cookbook contents
COPY . /cookbook/

CMD ["bash"]