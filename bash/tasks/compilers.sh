#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git build-essential ninja-build gettext cmake unzip curl \
  xclip g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev \
  libxkbcommon-dev python3-pip
