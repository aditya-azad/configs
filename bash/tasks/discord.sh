#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y snapd
sudo systemctl enable --now snapd.socket
snap list discord >/dev/null 2>&1 || sudo snap install discord
