#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

mkdir -p "$HOME_DIR/.local/share/fonts"
chmod 0755 "$HOME_DIR/.local/share/fonts"
[[ -f "$HOME_DIR/.local/share/fonts/FiraCodeNerdFont-Regular.ttf" ]] || \
  unzip -o -q "$CONFIGS_REPO/font/FiraCode.zip" '*.ttf' -d "$HOME_DIR/.local/share/fonts"

fc-cache -f
