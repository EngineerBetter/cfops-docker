#!/bin/bash
set -eux

names=( terraform cf jq om fly bosh bbl yq credhub certstrap kubectl shellcheck)
for name in "${names[@]}"
do
  chmod +x /usr/bin/$name
  sync # docker bug requires this
  ls -la /usr/bin/
  $name --version
done
