#!/bin/bash

bash ./hcloud-project-init/scripts/validate.sh 1
if [ $? -eq 1 ]; then
    exit 0
fi
bash ./hcloud-project-init/scripts/update.sh