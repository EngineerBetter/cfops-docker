#!/bin/sh

set -eux

apk --no-cache add \
  bash \
  build-base \
  curl \
  git \
  parallel \
  python \
  python-dev \
  ruby \
  ruby-dev

# GO binaries don't work on alpine without this
mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# Make binaries executable
./install_binaries.sh && rm install_binaries.sh

# Install Google Cloud SDK
curl -sSL https://sdk.cloud.google.com | bash

# Install AWS CLI
unzip awscli-bundle.zip \
  && rm awscli-bundle.zip \
  && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
  && rm -r awscli-bundle \
  && aws --version

# Install uaac
gem install --no-document --no-update-sources --verbose cf-uaac \
  && rm -rf /usr/lib/ruby/gems/2.5.0/cache/
