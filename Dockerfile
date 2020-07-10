FROM golang:latest as go

RUN go get github.com/onsi/ginkgo/ginkgo \
  github.com/onsi/gomega \
  gopkg.in/alecthomas/gometalinter.v2 \
  github.com/krishicks/yaml-patch/cmd/yaml-patch \
  github.com/EngineerBetter/yml2env \
  gopkg.in/EngineerBetter/stopover.v2 \
  gopkg.in/EngineerBetter/stopover.v1 \
  && mv /go/bin/stopover.v1 /go/bin/stopover \
  && mv /go/bin/gometalinter.v2 /go/bin/gometalinter \
  && gometalinter --install

FROM alpine:latest

COPY --from=go /go/bin/ /usr/bin/

RUN apk --no-cache add \
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
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# Copy in binaries and make sure they are executable
COPY terraform cf jq om fly bosh bbl yq credhub certstrap kubectl shellcheck /usr/bin/
COPY install_binaries.sh .
RUN ./install_binaries.sh && rm install_binaries.sh

# Install Google Cloud SDK
RUN curl -sSL https://sdk.cloud.google.com | bash

# Adding the Google Cloud SDK package path to PATH
ENV PATH $PATH:/root/google-cloud-sdk/bin

# Copy in AWS source files
COPY awscli-bundle.zip ./

# Install AWS CLI
RUN unzip awscli-bundle.zip \
  && rm awscli-bundle.zip \
  && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
  && rm -r awscli-bundle \
  && aws --version

# Install uaac
RUN gem install --no-document --no-update-sources --verbose cf-uaac \
  && rm -rf /usr/lib/ruby/gems/2.5.0/cache/

COPY verify_image.sh /tmp/verify_image.sh
RUN /tmp/verify_image.sh && rm /tmp/verify_image.sh
