#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo snap remove --purge firefox    2>/dev/null || true
sudo snap remove --purge thunderbird 2>/dev/null || true
sudo env DEBIAN_FRONTEND=noninteractive apt-get -y purge firefox thunderbird 2>/dev/null || true
sudo env DEBIAN_FRONTEND=noninteractive apt-get -y autoremove --purge
