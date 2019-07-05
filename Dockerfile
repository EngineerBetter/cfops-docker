FROM golang:latest as go

RUN go get github.com/onsi/ginkgo/ginkgo \
  github.com/onsi/gomega \
  gopkg.in/alecthomas/gometalinter.v2 \
  github.com/krishicks/yaml-patch/cmd/yaml-patch \
  github.com/EngineerBetter/yml2env \
  gopkg.in/EngineerBetter/stopover.v2 \
  gopkg.in/EngineerBetter/stopover.v1 \
  && mv /go/bin/stopover.v1 /go/bin/stopover

# Install gometalinter
RUN mv /go/bin/gometalinter.v2 /go/bin/gometalinter && \
  gometalinter --install

FROM alpine:latest

# Copy in go tools from previous build step
COPY --from=go /go/bin/ /usr/bin/

# Copy in binaries
COPY terraform cf jq om fly bosh bbl yq credhub certstrap kubectl shellcheck /usr/bin/

# Copy in scripts and AWS CLI zip
COPY install_binaries.sh build_image.sh awscli-bundle.zip ./

# Install everything
RUN ./build_image.sh && rm ./build_image.sh

# Adding the Google Cloud SDK package path to PATH
ENV PATH $PATH:/root/google-cloud-sdk/bin

# Copy in image verification script
COPY verify_image.sh verify_image.sh
RUN ./verify_image.sh && rm ./verify_image.sh
