#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y \
  cmake build-essential \
  qt6-base-dev qt6-declarative-dev qt6-wayland-dev \
  qml6-module-qt5compat-graphicaleffects \
  qml6-module-qtquick-controls \
  qml6-module-qtquick-layouts \
  qml6-module-qtquick-shapes \
  libwayland-dev wayland-protocols \
  libpipewire-0.3-dev libspa-0.2-dev libpulse-dev \
  libdbus-1-dev libxkbcommon-dev \
  playerctl cava \
  libnotify-bin

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

qs_link="$HOME_DIR/.config/quickshell"
mkdir -p "$HOME_DIR/.config"
if [[ -L "$qs_link" ]]; then
  rm -f "$qs_link"
elif [[ -e "$qs_link" ]]; then
  rm -rf "$qs_link"
fi
ln -sfn "$CONFIGS_REPO/quickshell" "$qs_link"

chmod +x "$CONFIGS_REPO/quickshell/scripts/find-apps.sh"
