#!/bin/bash
set -e

REVERSE=false
START_INDEX=1

while [[ $# -gt 0 ]]; do
  case $1 in
    -r|--reverse)
      REVERSE=true
      shift
      ;;
    -l|--layer)
      # Ensure an argument is provided for -l
      if [[ -n "$2" && "$2" =~ ^[0-9]+$ ]]; then
        START_INDEX="$2"
        shift 2
      else
        echo "Error: --layer requires a numeric index."
        exit 1
      fi
      ;;
    *)
      COMMAND=("$@")
      break
      ;;
  esac
done

layers=()
shopt -s nullglob
for dir in ./terraform/layers/*/; do
  layers+=("$(basename "$dir")")
done
shopt -u nullglob

layers=("${layers[@]:$START_INDEX - 1}")

layers_temp=()
if [[ "$REVERSE" == true ]]; then
    for (( i=${#layers[@]}-1; i>=0; i-- )); do
        layers_temp+=( "${layers[i]}" )
    done
    layers=("${layers_temp[@]}")
fi

for layer in "${layers[@]}"; do
  LAYER_PATH="./terraform/layers/$layer"
  if [ ${#COMMAND[@]} -eq 0 ]; then
     echo "$LAYER_PATH"
  else
     echo "------------------------------------------------------------"
     echo "Layer: $layer"
     echo "Command: terraform ${COMMAND[*]}"
     echo "------------------------------------------------------------"
     (cd "$LAYER_PATH" && terraform "${COMMAND[@]}")
     echo ""
  fi
done