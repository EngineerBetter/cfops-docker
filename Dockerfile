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

FROM amazon/aws-cli:latest as aws

FROM alpine:latest

COPY --from=go /go/bin/ /usr/bin/

COPY --from=aws /usr/local/bin/aws /usr/bin/aws

RUN apk --no-cache add \
  bash \
  build-base \
  curl \
  git \
  parallel \
  python3 \
  python3-dev \
  ruby \
  ruby-dev \
  && mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# Copy in binaries and make sure they are executable
COPY terraform cf jq om fly bosh bbl yq credhub certstrap kubectl shellcheck /usr/bin/
COPY install_binaries.sh .
RUN ./install_binaries.sh && rm install_binaries.sh

# Install Google Cloud SDK
RUN curl -sSL https://sdk.cloud.google.com | bash

# Adding the Google Cloud SDK package path to PATH
ENV PATH $PATH:/root/google-cloud-sdk/bin

COPY verify_image.sh /tmp/verify_image.sh
RUN /tmp/verify_image.sh && rm /tmp/verify_image.sh
