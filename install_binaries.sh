#!/bin/bash
set -eux

names=( terraform cf jq om fly bosh bbl yq credhub certstrap kubectl shellcheck)
for name in "${names[@]}"
do
  chmod +x /usr/bin/$name
  sync # docker bug requires this
  stat /usr/bin/$name
  echo $name
  $name --version
done
