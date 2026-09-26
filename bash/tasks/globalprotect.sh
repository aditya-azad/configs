#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

command -v gpclient >/dev/null || {
  command -v add-apt-repository >/dev/null \
    || sudo apt-get install -y software-properties-common
  sudo add-apt-repository -y ppa:yuezk/globalprotect-openconnect
  sudo apt-get update
  sudo apt-get install -y globalprotect-openconnect
}
