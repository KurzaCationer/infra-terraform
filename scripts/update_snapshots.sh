#!/bin/bash
set -e

source ./scripts/set_token.sh
bash ./hcloud-project-init/scripts/update.sh "$@"