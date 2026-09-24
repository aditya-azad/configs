#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y kanshi

mkdir -p "$HOME_DIR/.config/kanshi"
chmod 0755 "$HOME_DIR/.config/kanshi"
ln -sfn "$CONFIGS_REPO/hypr/kanshi/config" "$HOME_DIR/.config/kanshi/config"
