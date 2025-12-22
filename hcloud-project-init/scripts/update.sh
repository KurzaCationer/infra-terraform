#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

hcloud context create context --token-from-env

# Build new snapshots
packer init ./hcloud-project-init/hcloud-microos-snapshots.pkr.hcl
packer build ./hcloud-project-init/hcloud-microos-snapshots.pkr.hcl

# Delete old snapshots
hcloud image list -a arm -l microos-snapshot=yes --output json | jq '.[:-1]' | jq '.[].id' | xargs -I {} hcloud image delete {}
hcloud image list -a x86 -l microos-snapshot=yes --output json | jq '.[:-1]' | jq '.[].id' | xargs -I {} hcloud image delete {}

hcloud context delete context