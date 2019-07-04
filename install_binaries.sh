#!/bin/bash
set -eux

names=( terraform cf jq om fly bosh bbl yq credhub certstrap shellcheck)
for name in "${names[@]}"
do
  chmod +x /usr/bin/$name
  sync # docker bug requires this
  $name --version
done

chmod +x /usr/bin/kubectl
sync
command -v kubectl
