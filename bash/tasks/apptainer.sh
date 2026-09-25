#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

[[ "$ARCH" == "x86_64" ]] || { echo "!! apptainer: skipping (only x86_64 prebuilt deb)" >&2; exit 0; }

apptainer_version="1.5.4"
apptainer_deb="apptainer_${apptainer_version}-trixie+_amd64.deb"

installed="$(dpkg-query -W -f='${Version}' apptainer 2>/dev/null || true)"
if [[ "$installed" != "$apptainer_version" ]]; then
  [[ -f "/tmp/$apptainer_deb" ]] || \
    curl -fsSL -o "/tmp/$apptainer_deb" "https://github.com/apptainer/apptainer/releases/download/v${apptainer_version}/$apptainer_deb"
  sudo apt-get install -y "/tmp/$apptainer_deb"
fi
