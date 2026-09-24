#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y \
  cmake build-essential \
  qt6-base-dev qt6-declarative-dev qt6-wayland-dev \
  libwayland-dev wayland-protocols \
  libpipewire-0.3-dev libspa-0.2-dev libpulse-dev \
  libdbus-1-dev libxkbcommon-dev \
  fuzzel libnotify-bin

if [[ ! -x /usr/local/bin/quickshell ]]; then
  if [[ ! -d "$CODE_DIR/quickshell/.git" ]]; then
    git clone --recursive https://git.outfoxxed.me/outfoxxed/quickshell.git "$CODE_DIR/quickshell"
  fi
  cd "$CODE_DIR/quickshell"
  git pull || true
  git submodule update --init --recursive || true
  mkdir -p build
  cd build
  cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local
  make -j"$NPROC"
  sudo make install
  sudo ldconfig
fi

mkdir -p "$HOME_DIR/.config/quickshell"
chmod 0755 "$HOME_DIR/.config/quickshell"

for f in shell.qml Panel.qml Notifications.qml; do
  ln -sfn "$CONFIGS_REPO/quickshell/$f" "$HOME_DIR/.config/quickshell/$f"
done
