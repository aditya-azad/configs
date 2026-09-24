#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y \
  fonts-noto fonts-noto-core fonts-noto-color-emoji fonts-firacode

mkdir -p "$HOME_DIR/.config/fontconfig"
chmod 0755 "$HOME_DIR/.config/fontconfig"
cat > "$HOME_DIR/.config/fontconfig/fonts.conf" <<'XML'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fonts:dtd:fontconfig">
<fontconfig>
  <alias><family>serif</family>      <prefer><family>Noto Serif</family>      <family>Noto Color Emoji</family></prefer></alias>
  <alias><family>sans-serif</family> <prefer><family>Noto Sans</family>       <family>Noto Color Emoji</family></prefer></alias>
  <alias><family>monospace</family>  <prefer><family>FiraCode Nerd Font</family><family>Noto Color Emoji</family></prefer></alias>
  <alias><family>emoji</family>      <prefer><family>Noto Color Emoji</family></prefer></alias>
</fontconfig>
XML
chmod 0644 "$HOME_DIR/.config/fontconfig/fonts.conf"

mkdir -p "$HOME_DIR/.local/share/fonts"
chmod 0755 "$HOME_DIR/.local/share/fonts"
[[ -f "$HOME_DIR/.local/share/fonts/FiraCodeNerdFont-Regular.ttf" ]] || \
  unzip -o -q "$CONFIGS_REPO/font/FiraCode.zip" -d "$HOME_DIR/.local/share/fonts"

fc-cache -f
