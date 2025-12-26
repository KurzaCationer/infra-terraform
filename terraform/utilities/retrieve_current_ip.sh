#!/bin/bash

TIMEOUT=5
IP=""

if [[ "$1" == "--ipv4" ]]; then
  IP=$(curl -s -4 --connect-timeout $TIMEOUT https://ipv4.icanhazip.com || exit 1)

elif [[ "$1" == "--ipv6" ]]; then
  IP=$(curl -s -6 --connect-timeout $TIMEOUT https://ipv6.icanhazip.com || exit 1)
fi

IP=$(echo "$IP" | tr -d '[:space:]')

printf '{"ip": "%s"}\n' "$IP"