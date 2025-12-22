#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

bash ./hcloud-project-init/validate-snapshots.sh
bash ./hcloud-project-init/update-snapshots.sh