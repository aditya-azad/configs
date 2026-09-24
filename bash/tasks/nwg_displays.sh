#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y \
  gir1.2-gtk-3.0 gir1.2-gtk-layer-shell-0.1 libgtk-layer-shell0 \
  python3-gi python3-i3ipc python3-build python3-installer python3-wheel \
  python3-setuptools git

if [[ -d "$CODE_DIR/nwg-displays/.git" ]]; then
  git -C "$CODE_DIR/nwg-displays" fetch --all 2>/dev/null || true
  git -C "$CODE_DIR/nwg-displays" checkout v0.4.4 2>/dev/null || true
else
  git clone --depth 1 --branch v0.4.4 https://github.com/nwg-piotr/nwg-displays.git "$CODE_DIR/nwg-displays"
fi

if [[ ! -x /usr/local/bin/nwg-displays ]]; then
  bash -c "set -e; cd '$CODE_DIR/nwg-displays'; rm -rf dist; python3 -m build --wheel --no-isolation"
  sudo python3 -m installer "$CODE_DIR"/nwg-displays/dist/*.whl
  sudo install -Dm 644 -t /usr/share/applications "$CODE_DIR/nwg-displays/nwg-displays.desktop"
  sudo install -Dm 644 -t /usr/share/pixmaps "$CODE_DIR/nwg-displays/nwg-displays.svg"
fi
