#!/usr/bin/env bash

setup_local_bin() {
  mkdir -p "$HOME_DIR/.local/bin"
  chmod 0755 "$HOME_DIR/.local/bin"
}

link_tool() {
  local dir="$1" name="${2:-$1}"
  setup_local_bin
  ln -sfn "$PACKAGES_DIR/$dir/$name" "$HOME_DIR/.local/bin/$name"
}

setup_bin_links() {
  link_tool wpi-vpn
  link_tool start-mac
  link_tool distrobox db
  link_tool ghclone
}
