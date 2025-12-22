#!/bin/bash
set -e

bash ./hcloud-project-init/scripts/initialize.sh
bash ./terraform/scripts/upgrade.sh