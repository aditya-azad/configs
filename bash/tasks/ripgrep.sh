#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

[[ -x "$CARGO_BIN/rg" ]] || "$CARGO_BIN/cargo" install ripgrep
