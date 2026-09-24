#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y \
  thunar thunar-archive-plugin thunar-volman file-roller gvfs gvfs-backends
