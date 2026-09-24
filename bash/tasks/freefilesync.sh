#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

[[ "$ARCH" == "x86_64" ]] || { echo "!! freefilesync: skipping (only x86_64)" >&2; exit 0; }

freefilesync_version="14.12"
freefilesync_archive="FreeFileSync_${freefilesync_version}_Linux_x86_64.tar.gz"
freefilesync_installer="FreeFileSync_${freefilesync_version}_Install.run"

[[ -f "/tmp/$freefilesync_archive" ]] || \
  curl -fsSL -o "/tmp/$freefilesync_archive" "https://freefilesync.org/download/$freefilesync_archive"

[[ -f "/tmp/$freefilesync_installer" ]] || tar xzf "/tmp/$freefilesync_archive" -C /tmp

if [[ ! -x /opt/FreeFileSync/FreeFileSync ]]; then
  installer="/tmp/$freefilesync_installer"
  dest="/opt/FreeFileSync"
  sudo mkdir -p "$dest"
  offset=$(LC_ALL=C grep -a -b -o $'\x1f\x8b\x08' "$installer" | head -n1 | cut -d: -f1)
  tail -c +$((offset + 1)) "$installer" | sudo tar xz -C "$dest"
  sudo chmod +x "$dest/FreeFileSync" "$dest/RealTimeSync" \
                "$dest/Bin/FreeFileSync_x86_64" "$dest/Bin/RealTimeSync_x86_64"
fi
