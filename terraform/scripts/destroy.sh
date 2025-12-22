#!/bin/bash
set -e

bash ./terraform/scripts/utilities/foreach_layer.sh -r "$@" init
bash ./terraform/scripts/utilities/foreach_layer.sh -r "$@" destroy -auto-approve -var-file="$(pwd)/terraform/secrets/terraform.tfvars"