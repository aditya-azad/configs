#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

[[ -x "$CARGO_BIN/zellij" ]] || "$CARGO_BIN/cargo" install zellij

mkdir -p "$HOME_DIR/.config"
chmod 0755 "$HOME_DIR/.config"
ln -sfn "$CONFIGS_REPO/zellij" "$HOME_DIR/.config/zellij"
