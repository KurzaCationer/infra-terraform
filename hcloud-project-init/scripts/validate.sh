#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

hcloud context create context --token-from-env

# Delete old snapshots

arm_valid=false
x86_valid=false

while IFS= read -r output; do
    arm_valid=true
done < <(hcloud image list -a arm -l microos-snapshot=yes --output json | jq '.[0:]' | jq '.[].id')

while IFS= read -r output; do
    x86_valid=true
done < <(hcloud image list -a x86 -l microos-snapshot=yes --output json | jq '.[0:]' | jq '.[].id')

if [[ $arm_valid == true && $x86_valid == true ]]
then
    echo "Snapshots valid"
    exit 1
fi