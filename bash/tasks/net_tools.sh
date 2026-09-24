#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y net-tools
