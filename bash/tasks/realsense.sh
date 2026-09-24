#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y v4l-utils
mkdir -p "$CODE_DIR"
chmod 0755 "$CODE_DIR"

if [[ -d "$CODE_DIR/librealsense/.git" ]]; then
  git -C "$CODE_DIR/librealsense" fetch --all --tags 2>/dev/null || true
  git -C "$CODE_DIR/librealsense" checkout v2.56.3 2>/dev/null || true
else
  git clone --branch v2.56.3 https://github.com/IntelRealSense/librealsense.git "$CODE_DIR/librealsense"
fi

sudo bash -c "cd '$CODE_DIR/librealsense'; bash ./scripts/setup_udev_rules.sh"
