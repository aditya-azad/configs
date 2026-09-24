#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

ln -sfn "$CONFIGS_REPO/refree" "$HOME_DIR/.refree"
