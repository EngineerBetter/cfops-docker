# CF-Ops

![CI](https://ci.engineerbetter.com/api/v1/teams/main/pipelines/cfops-docker/badge)

A docker image for pipelining the deployment and operation of Cloud Platforms

Intended to be a lighter version of [pcf-ops](https://github.com/EngineerBetter/pcfops-docker) based on alpine instead of ubuntu.

Pipeline: https://ci.engineerbetter.com/teams/main/pipelines/cfops-docker

## Usage

`docker pull engineerbetter/cf-ops`

## Included tools

Base alpine linux plus the following

|tool|description|docs|
|:-|:-:|:-:|
|`aws`|CLI for interacting with AWS|[reference](https://docs.aws.amazon.com/cli/latest/reference)|
|`bash`||[reference](https://www.gnu.org/software/bash/manual/bash.html)|
|`bbl`|CLI for standing up a BOSH director|[reference](https://github.com/cloudfoundry/bosh-bootloader)|
|`bosh`|CLI for interacting with a BOSH director|[reference](https://bosh.io/docs/cli-v2/)|
|`certstrap`|CLI for creating CAs, certificate requests, and signed certificates|[reference](https://github.com/square/certstrap)|
|`cf`|CLI for interacting with Cloud Foundry|[reference](https://docs.cloudfoundry.org/cf-cli/)|
|`credhub`|CLI for interacting with Credhub credential management servers|[reference](https://github.com/cloudfoundry-incubator/credhub-cli)|
|`curl`|CLI to transfer data from or to a server|[reference](https://curl.haxx.se/docs/manpage.html)|
|`fly`|CLI for interacting with a Concourse deployment|[reference](https://concourse-ci.org/fly.html)|
|`gcloud`|CLI for interacting with Google Cloud Platform|[reference](https://cloud.google.com/sdk/gcloud/)|
|`ginkgo`|BDD testing framework in Golang|[reference](http://onsi.github.io/ginkgo/)|
|`git`|Source control tool|[reference](https://git-scm.com/docs)|
|`gometalinter`|Linting tool for Golang code|[reference](https://godoc.org/gopkg.in/alecthomas/gometalinter.v2)|
|`jq`|CLI for manipulating JSON|[reference](https://stedolan.github.io/jq/manual/)|
|`kubectl`|CLI for interacting with Kubernetes|[reference](https://kubernetes.io/docs/reference/kubectl/overview/)|
|`om`|CLI for interacting with Pivotal Operations Manager|[reference](https://github.com/pivotal-cf/om/blob/master/docs/README.md)|
|`parallel`|Build and execute shell command lines from standard input in parallel|[reference](https://www.gnu.org/software/parallel/man.html)|
|`shellcheck`|Static analysis tool for shell scripts|[reference](https://github.com/koalaman/shellcheck)|
|`stopover`|CLI to emit a YAML file listing versions of all resources for a given Concourse build (For Concourse <v5.0)|[reference](https://github.com/EngineerBetter/stopover)|
|`stopover.v2`|CLI to emit a YAML file listing versions of all resources for a given Concourse build (For Concourse >=v5.0)|[reference](https://github.com/EngineerBetter/stopover)|
|`terraform`|Infrastructure as code|[reference](https://www.terraform.io/intro/index.html)|
|`uaac`|CLI to interact with a UAA|[reference](https://github.com/cloudfoundry/cf-uaac)|
|`yaml-patch`|CLI for applying patches to YAML files|[reference](https://github.com/krishicks/yaml-patch)|
|`yml2env`|Run a command with env vars from a YAML file|[reference](https://github.com/EngineerBetter/yml2env)|
|`yq`|`jq` wrapper for YAML|[reference](https://github.com/kislyuk/yq)|

Languages installed via `apk add`

|Language|
|:-|
|ruby|
|ruby-dev|
|python|
|python-dev|
