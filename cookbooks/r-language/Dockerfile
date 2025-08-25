FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages and Ruby 3.1
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    software-properties-common \
    && add-apt-repository ppa:brightbox/ruby-ng \
    && apt-get update \
    && apt-get install -y ruby3.1 ruby3.1-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Chef 18 (includes Ruby 3.1)
RUN curl -L https://omnitruck.chef.io/install.sh | bash -s -- -v 18

# Set up working directory
WORKDIR /opt/chef-r-language-cookbook

# Copy cookbook files
COPY . .

# Install Ruby dependencies
RUN gem install bundler && bundle install

# Run tests
CMD ["bundle", "exec", "rspec"]
