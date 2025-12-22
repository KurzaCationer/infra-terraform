#!/bin/bash
set -e

bash ./hcloud-project-init/scripts/validate.sh
bash ./terraform/scripts/apply.sh