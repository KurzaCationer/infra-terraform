#!/bin/bash
set -e

bash ./terraform/scripts/utilities/foreach_layer.sh "$@" init -upgrade