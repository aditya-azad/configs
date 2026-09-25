#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

if [[ "$(timedatectl show -p Timezone --value)" != "America/New_York" ]]; then
  sudo timedatectl set-timezone America/New_York
fi

sudo apt-get install -y chrony
sudo systemctl disable --now systemd-timesyncd.service 2>/dev/null || true
sudo systemctl enable --now chrony
