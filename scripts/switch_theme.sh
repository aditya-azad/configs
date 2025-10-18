#!/bin/bash

set -e

THEME="$HOME/.config/.theme"
if [ ! -f "$THEME" ]; then
  echo "0" > "$THEME"
fi

state=$(cat "$THEME")
if [ "$state" -eq 0 ]; then
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
  gsettings set org.gnome.desktop.interface gtk-theme Adwaita
  gsettings set org.gnome.desktop.interface icon-theme Yaru
  cp ~/code/configs/nvim/lua/light_theme.lua ~/code/configs/nvim/lua/theme.lua
  cp ~/code/configs/alacritty/light_theme.toml ~/.config/alacritty/theme.toml
  cp ~/code/configs/btop/themes/light_theme.theme ~/.config/btop/themes/theme.theme
  echo "1" > "$THEME"
else
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
  gsettings set org.gnome.desktop.interface icon-theme Yaru-dark
  cp ~/code/configs/nvim/lua/dark_theme.lua ~/code/configs/nvim/lua/theme.lua
  cp ~/code/configs/alacritty/dark_theme.toml ~/.config/alacritty/theme.toml
  cp ~/code/configs/btop/themes/dark_theme.theme ~/.config/btop/themes/theme.theme
  echo "0" > "$THEME"
fi
