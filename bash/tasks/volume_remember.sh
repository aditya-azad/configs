#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y pulseaudio-utils

mkdir -p "$HOME_DIR/.local/bin"
chmod 0755 "$HOME_DIR/.local/bin"
install -m 0755 "$PACKAGES_DIR/volume-remember/volume-remember" "$HOME_DIR/.local/bin/volume-remember"

mkdir -p "$HOME_DIR/.config/systemd/user"
chmod 0755 "$HOME_DIR/.config/systemd/user"
install -m 0644 "$PACKAGES_DIR/volume-remember/volume-remember.service" "$HOME_DIR/.config/systemd/user/volume-remember.service"
systemctl --user daemon-reload
systemctl --user enable --now volume-remember 2>/dev/null || true
