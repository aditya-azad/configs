#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y --no-install-recommends \
  thunar thunar-archive-plugin thunar-volman file-roller gvfs udisks2 tumbler
