#!/bin/bash
set -e

bash ./terraform/scripts/utilities/foreach_layer.sh "$@" refresh -var-file="$(pwd)/terraform/secrets/terraform.tfvars"
bash ./terraform/scripts/utilities/foreach_layer.sh "$@" output -json | jq 'to_entries | .[] | select(.key | contains("kubeconfig") | not) | {key: .key, value: .value.value}'