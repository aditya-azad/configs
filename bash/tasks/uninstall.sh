#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo env DEBIAN_FRONTEND=noninteractive apt-get -y purge \
  apport apport-symptoms whoopsie whoopsie-preferences \
  ubuntu-report ubuntu-pro-client landscape-client popularity-contest \
  motd-news-config snapd fwupd-snap 2>/dev/null || true

sudo env DEBIAN_FRONTEND=noninteractive apt-get -y autoremove --purge
