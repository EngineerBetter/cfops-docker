FROM golang:latest as go

ARG GO111MODULE=auto

RUN go get github.com/onsi/ginkgo/ginkgo \
  github.com/onsi/gomega \
  gopkg.in/alecthomas/gometalinter.v2 \
  github.com/EngineerBetter/yaml-patch/cmd/yaml-patch \
  github.com/EngineerBetter/yml2env \
  github.com/santhosh-tekuri/jsonschema/cmd/jv \
  gopkg.in/EngineerBetter/stopover.v2 \
  gopkg.in/EngineerBetter/stopover.v1 \
  && mv /go/bin/stopover.v1 /go/bin/stopover

# Install gometalinter
RUN mv /go/bin/gometalinter.v2 /go/bin/gometalinter && \
  gometalinter --install

FROM amazon/aws-cli:latest as aws

FROM python:3.7-alpine

COPY --from=go /go/bin/ /usr/bin/

COPY --from=aws /usr/local/bin/aws /usr/bin/aws

RUN apk --no-cache add \
  bash \
  build-base \
  curl \
  fd \
  git \
  libc6-compat \
  parallel \
  ruby \
  ruby-dev \
  && curl -sSL https://sdk.cloud.google.com | bash

# Copy in binaries and make sure they are executable
COPY terraform cf jq om fly bosh bbl yq credhub certstrap kubectl shellcheck /usr/bin/
COPY install_binaries.sh .
RUN ./install_binaries.sh && rm install_binaries.sh

# Adding the Google Cloud SDK package path to PATH
ENV PATH $PATH:/root/google-cloud-sdk/bin
RUN gcloud components install gke-gcloud-auth-plugin

COPY verify_image.sh /tmp/verify_image.sh
RUN /tmp/verify_image.sh && rm /tmp/verify_image.sh
