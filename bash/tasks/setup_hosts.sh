#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

lineinfile --sudo /etc/hosts '^\s*192\.168\.55\.1\s+jetson\s*$' "192.168.55.1 jetson"
