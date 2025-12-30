#!/bin/bash

FILE="./terraform/secrets/terraform.tfvars"

# Check if file exists
if [ ! -f "$FILE" ]; then
    echo "Error: $FILE not found."
    exit 1
fi

# Extract the value using awk
# 1. Look for the line starting with hcloud_token
# 2. Use the double quote (") as a field separator
# 3. Print the second field (the content between the quotes)
TOKEN=$(grep '^hcloud_token' "$FILE" | awk -F'"' '{print $2}')

if [ -z "$TOKEN" ]; then
    echo "Error: hcloud_token not found in $FILE"
    exit 1
fi

# Export the variable
export HCLOUD_TOKEN="$TOKEN"

# Confirmation (optional)
echo "HCLOUD_TOKEN has been set."