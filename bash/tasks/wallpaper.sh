#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y swaybg

systemctl --user disable --now hyprpaper 2>/dev/null || true
rm -f "$HOME_DIR/.config/hypr/hyprpaper.conf"

mkdir -p "$HOME_DIR/.local/bin"
chmod 0755 "$HOME_DIR/.local/bin"
install -m 0755 "$PACKAGES_DIR/wallpaper/swaybg-wallpaper" "$HOME_DIR/.local/bin/swaybg-wallpaper"

mkdir -p "$HOME_DIR/.config/systemd/user"
chmod 0755 "$HOME_DIR/.config/systemd/user"
install -m 0644 "$PACKAGES_DIR/wallpaper/swaybg.service" "$HOME_DIR/.config/systemd/user/swaybg.service"
systemctl --user daemon-reload

STATE_DIR="${XDG_STATE_HOME:-$HOME_DIR/.local/state}/themes"
if [[ -f "$STATE_DIR/current.name" ]]; then
  name="$(cat "$STATE_DIR/current.name")"
  conf="$HOME_DIR/.local/share/theme-switch/themes/$name/colors.conf"
  [[ -f "$conf" ]] || conf="$PACKAGES_DIR/theme-switch/themes/$name/colors.conf"
  if [[ -f "$conf" ]]; then
    wp="$(awk -F= '/^WALLPAPER=/{gsub(/"/,"",$2); print $2}' "$conf")"
    if [[ -n "$wp" ]]; then
      mkdir -p "$STATE_DIR/current"
      printf '%s\n' "$HOME_DIR/code/configs/wallpapers/$wp" > "$STATE_DIR/current/wallpaper"
    fi
  fi
fi

systemctl --user enable --now swaybg 2>/dev/null || true
