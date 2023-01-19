FROM python:3.10.5-alpine3.16 as builder

ARG AWS_CLI_VERSION=2.9.0
RUN apk add --no-cache git unzip groff build-base libffi-dev cmake
RUN git clone --single-branch --depth 1 -b ${AWS_CLI_VERSION} https://github.com/aws/aws-cli.git

WORKDIR aws-cli
RUN python -m venv venv
RUN . venv/bin/activate
RUN scripts/installers/make-exe
RUN unzip -q dist/awscli-exe.zip
RUN aws/install --bin-dir /aws-cli-bin
RUN /aws-cli-bin/aws --version

# reduce image size: remove autocomplete and examples
RUN rm -rf \
  /usr/local/aws-cli/v2/current/dist/aws_completer \
  /usr/local/aws-cli/v2/current/dist/awscli/data/ac.index \
  /usr/local/aws-cli/v2/current/dist/awscli/examples
RUN find /usr/local/aws-cli/v2/current/dist/awscli/data -name completions-1*.json -delete
RUN find /usr/local/aws-cli/v2/current/dist/awscli/botocore/data -name examples-1.json -delete

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

FROM python:3.10.5-alpine3.16

COPY --from=builder /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=builder /aws-cli-bin/ /usr/local/bin/
COPY --from=go /go/bin/* /usr/bin/
COPY --from=golang:1.19.5-alpine /usr/local/go/ /usr/local/go/

ENV PATH="/usr/local/go/bin:${PATH}"

RUN apk --no-cache add \
  bash \
  build-base \
  curl \
  fd \
  git \
  gnupg \
  libc6-compat \
  parallel \
  python3 \
  python3-dev \
  ruby \
  ruby-dev \
  && curl -sSL https://sdk.cloud.google.com | bash

# Copy in binaries and make sure they are executable
COPY terraform cf jq om fly bosh bbl yq credhub certstrap kubectl shellcheck /usr/bin/
COPY install_binaries.sh .
RUN ./install_binaries.sh && rm install_binaries.sh

# Install UAAC
RUN bash -l -c 'gem install --no-document --no-update-sources --verbose cf-uaac'

# Adding the Google Cloud SDK package path to PATH
ENV PATH $PATH:/root/google-cloud-sdk/bin
RUN gcloud components install gke-gcloud-auth-plugin

COPY verify_image.sh /tmp/verify_image.sh
RUN /tmp/verify_image.sh && rm /tmp/verify_image.sh
