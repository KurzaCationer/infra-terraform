#!/bin/bash
set -e

source ./scripts/set_token.sh
bash ./hcloud-project-init/scripts/validate.sh 0
bash ./terraform/scripts/apply.sh "$@"