#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

update_host() {
  local ip="$1" name="$2"
  if sudo grep -qE "^\s*${ip}\s+${name}\s*$" /etc/hosts; then
    sudo sed -i -E "s|^\s*${ip}\s+${name}\s*$|${ip} ${name}|" /etc/hosts
  else
    echo "${ip} ${name}" | sudo tee -a /etc/hosts >/dev/null
  fi
}

update_host "192.168.55.1" "jetson"
update_host "130.215.183.33" "bizon"
