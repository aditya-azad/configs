#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y --no-install-recommends \
  thunar thunar-archive-plugin thunar-volman file-roller gvfs udisks2 tumbler \
  xfconf

ADW_GTK3_VERSION="6.5"
adw_marker="/usr/local/share/adw-gtk3-version"
adw_installed=""
[[ -f "$adw_marker" ]] && adw_installed="$(cat "$adw_marker")"

if [[ "$ADW_GTK3_VERSION" != "$adw_installed" || ! -d /usr/share/themes/adw-gtk3 ]]; then
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/adw-gtk3v${ADW_GTK3_VERSION}.tar.xz" \
    "https://github.com/lassekongo83/adw-gtk3/releases/download/v${ADW_GTK3_VERSION}/adw-gtk3v${ADW_GTK3_VERSION}.tar.xz"
  tar -xJf "$tmp/adw-gtk3v${ADW_GTK3_VERSION}.tar.xz" -C "$tmp"
  sudo rm -rf /usr/share/themes/adw-gtk3 /usr/share/themes/adw-gtk3-dark
  sudo cp -r "$tmp/adw-gtk3" "$tmp/adw-gtk3-dark" /usr/share/themes/
  printf '%s\n' "$ADW_GTK3_VERSION" | sudo tee "$adw_marker" >/dev/null
  sudo chmod 0644 "$adw_marker"
  rm -rf "$tmp"
fi

gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark" 2>/dev/null || true

xfconf-query -c thunar -p /last-menubar-visible -n -t bool -s false 2>/dev/null || \
  xfconf-query -c thunar -p /last-menubar-visible -s false 2>/dev/null || true

for v in gtk-3.0 gtk-4.0; do
  mkdir -p "$HOME_DIR/.config/$v"
  [[ -f "$HOME_DIR/.config/$v/gtk.css" ]] || \
    cp -f "$PACKAGES_DIR/thunar/gtk.css" "$HOME_DIR/.config/$v/gtk.css"
done
