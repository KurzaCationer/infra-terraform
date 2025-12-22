#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

bash ./hcloud-project-init/scripts/validate.sh 1
bash ./hcloud-project-init/scripts/update.sh