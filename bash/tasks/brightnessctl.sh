#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y brightnessctl

if ! id -nG "$USERNAME" | grep -qw video; then
  sudo usermod -aG video "$USERNAME"
fi
