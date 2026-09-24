#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y curl

sudo install -d -m 0755 /usr/share/keyrings
tmp=$(mktemp)
curl -fsSL -o "$tmp" https://nvidia.github.io/libnvidia-container/gpgkey
sudo install -m 0644 "$tmp" /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
rm -f "$tmp"

curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
  | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
  | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list >/dev/null

sudo apt-get update
sudo apt-get install -y \
  nvidia-container-toolkit=1.17.8-1 \
  nvidia-container-toolkit-base=1.17.8-1 \
  libnvidia-container-tools=1.17.8-1 \
  libnvidia-container1=1.17.8-1
