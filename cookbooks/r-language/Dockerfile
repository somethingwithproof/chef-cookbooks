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

# Install Chef 18 from a pinned package with a published checksum, rather than
# piping an installer script straight into a shell.
ARG TARGETARCH
ARG CHEF_VERSION=18.11.11
ARG CHEF_SHA256_AMD64=2a8ec5eb97a8908c5a2b14acd7642038a226940d89f65561ce6ce364a052dfa0
ARG CHEF_SHA256_ARM64=fbb347e5368cfdcb6a24c5c19436b2f88428bc46341fcf5d0fee22979c735353
RUN set -eux; \
    arch="${TARGETARCH:-$(dpkg --print-architecture)}"; \
    case "$arch" in \
        amd64) sha256="$CHEF_SHA256_AMD64" ;; \
        arm64) sha256="$CHEF_SHA256_ARM64" ;; \
        *) echo "no pinned Chef package for architecture $arch" >&2; exit 1 ;; \
    esac; \
    curl -fsSL -o /tmp/chef.deb \
        "https://packages.chef.io/files/stable/chef/${CHEF_VERSION}/ubuntu/24.04/chef_${CHEF_VERSION}-1_${arch}.deb"; \
    echo "$sha256  /tmp/chef.deb" | sha256sum -c -; \
    dpkg -i /tmp/chef.deb; \
    rm -f /tmp/chef.deb

# Set up working directory
WORKDIR /opt/chef-r-language-cookbook

# Copy cookbook files
COPY . .

# Install Ruby dependencies
RUN gem install bundler && bundle install

# Run tests
CMD ["bundle", "exec", "rspec"]
