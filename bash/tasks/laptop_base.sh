#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y \
  thermald power-profiles-daemon bolt fwupd fwupd-signed \
  intel-microcode linux-headers-generic
sudo systemctl enable --now thermald.service
sudo systemctl enable --now power-profiles-daemon.service
