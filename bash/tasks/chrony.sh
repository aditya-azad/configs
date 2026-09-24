#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y chrony
sudo systemctl disable --now systemd-timesyncd.service 2>/dev/null || true
sudo systemctl enable --now chrony
