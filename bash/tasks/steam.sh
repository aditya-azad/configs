#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

[[ "$ARCH" == "x86_64" ]] || { echo "!! steam: skipping (only x86_64)" >&2; exit 0; }

[[ -f /tmp/steam.deb ]] || \
  curl -fsSL -o /tmp/steam.deb "https://cdn.fastly.steamstatic.com/client/installer/steam.deb"
sudo apt-get install -y /tmp/steam.deb
