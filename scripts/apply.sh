#!/bin/bash
set -e

bash ./hcloud-project-init/scripts/validate.sh 0
bash ./terraform/scripts/apply.sh "$@"