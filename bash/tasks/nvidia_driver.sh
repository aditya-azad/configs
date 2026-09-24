#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get install -y "nvidia-driver-$NVIDIA_DRIVER_VERSION"
