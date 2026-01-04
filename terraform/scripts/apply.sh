#!/bin/bash
set -e

bash ./terraform/scripts/utilities/foreach_layer.sh init
bash ./terraform/scripts/utilities/foreach_layer.sh apply "$@" -auto-approve -var-file="$(pwd)/terraform/secrets/terraform.tfvars"