#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

mkdir -p "$HOME_DIR/.local/bin"
chmod 0755 "$HOME_DIR/.local/bin"

[[ -x "$HOME_DIR/.local/kitty.app/bin/kitty" ]] || \
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

for bin in kitty kitten; do
  ln -sfn "$HOME_DIR/.local/kitty.app/bin/$bin" "$HOME_DIR/.local/bin/$bin"
done

mkdir -p "$HOME_DIR/.local/share/applications"
chmod 0755 "$HOME_DIR/.local/share/applications"
for f in kitty.desktop kitty-open.desktop; do
  cp -f "$HOME_DIR/.local/kitty.app/share/applications/$f" \
        "$HOME_DIR/.local/share/applications/$f"
  chmod 0644 "$HOME_DIR/.local/share/applications/$f"
  sed -i "s|^Icon=kitty|Icon=$HOME_DIR/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|" \
    "$HOME_DIR/.local/share/applications/$f"
  sed -i "s|^Exec=kitty|Exec=$HOME_DIR/.local/kitty.app/bin/kitty|" \
    "$HOME_DIR/.local/share/applications/$f"
done

mkdir -p "$HOME_DIR/.config"
chmod 0755 "$HOME_DIR/.config"
ln -sfn "$CONFIGS_REPO/kitty" "$HOME_DIR/.config/kitty"
