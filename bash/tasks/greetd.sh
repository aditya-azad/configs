#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y greetd tuigreet

sudo mkdir -p /etc/greetd
sudo chmod 0755 /etc/greetd

cfg_src="$CONFIGS_REPO/hypr/greetd/config.toml"
cfg_dst="/etc/greetd/config.toml"
cfg_changed=0
if [[ ! -f "$cfg_dst" ]] || ! diff -q "$cfg_src" "$cfg_dst" >/dev/null 2>&1; then
  cfg_changed=1
fi
if [[ "$cfg_changed" == 1 ]]; then
  sudo install -m 0644 "$cfg_src" "$cfg_dst"
fi

sudo systemctl enable greetd.service 2>/dev/null || true
