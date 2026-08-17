#!/usr/bin/env bash
# st.sh — theme toggle logic (ported from scripts/switch_theme.sh, gsettings dropped).
# Runtime inputs are pinned by the derivation: coreutils, hyprland (hyprctl),
# kitty, procps (for signals).
#
# @lightDir@ / @darkDir@ are substituted at build time by the derivation with
# absolute store paths to the baked-in theme resource dirs.
#
# 1. Toggle ~/.config/.theme (0=dark, 1=light) — matches the existing convention.
# 2. Copy the theme's per-app files into the live config locations.
# 3. hyprctl reload; signal running kitty instances; nvim reads theme.lua on next
#    open / :source.

set -euo pipefail

THEME_FILE="$HOME/.config/.theme"
LIGHT_DIR="@lightDir@"
DARK_DIR="@darkDir@"

mkdir -p "$HOME/.config/kitty/themes" "$HOME/.config/btop/themes" \
         "$HOME/code/configs-nix/dotfiles/nvim/lua"

[ -f "$THEME_FILE" ] || echo "0" > "$THEME_FILE"

state="$(cat "$THEME_FILE")"
if [ "$state" -eq 0 ]; then
  src="$LIGHT_DIR"   # dark -> light
  new_state=1
else
  src="$DARK_DIR"    # light -> dark
  new_state=0
fi

cp "$src/kitty.conf" "$HOME/.config/kitty/theme.conf"
cp "$src/btop.theme" "$HOME/.config/btop/themes/theme.theme"
cp "$src/nvim.lua"   "$HOME/code/configs-nix/dotfiles/nvim/lua/theme.lua"
echo "$new_state" > "$THEME_FILE"

# Reload Hyprland (picks up any wallpaper/config changes).
hyprctl reload || true

# Nudge running kitty windows to re-read theme.conf (kitty watches its config;
# SIGUSR1 triggers a reload for instances that need it).
pkill -USR1 -x kitty || true

echo "Theme switched to ${src##*/}."
