FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    ruby \
    ruby-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Chef
RUN curl -L https://omnitruck.chef.io/install.sh | bash -s -- -v 18

# Set up working directory
WORKDIR /opt/chef-r-language-cookbook

# Copy cookbook files
COPY . .

# Install Ruby dependencies
RUN gem install bundler && bundle install

# Run tests
CMD ["bundle", "exec", "rspec"]
