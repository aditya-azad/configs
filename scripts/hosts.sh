#!/usr/bin/env bash
set -euo pipefail

# Add hosts from ~/code/configs (bizon, jetson) to /etc/hosts, idempotently.

update_host() {
  local ip="$1" name="$2"
  if grep -qE "^[[:space:]]*${ip}[[:space:]]+${name}[[:space:]]*$" /etc/hosts; then
    sudo sed -i -E "s|^[[:space:]]*${ip}[[:space:]]+${name}[[:space:]]*$|${ip} ${name}|" /etc/hosts
  else
    echo "${ip} ${name}" | sudo tee -a /etc/hosts >/dev/null
  fi
}

update_host "192.168.55.1" "jetson"
update_host "130.215.183.33" "bizon"

echo "hosts updated:"
grep -E "jetson|bizon" /etc/hosts
