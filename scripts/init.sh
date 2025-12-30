#!/bin/bash
set -e

source ./scripts/set_token.sh
bash ./hcloud-project-init/scripts/initialize.sh
bash ./terraform/scripts/init.sh "$@"