#!/usr/bin/env bash

CONFIGS_REPO="$HOME/.config"
PACKAGES_DIR="$CONFIGS_REPO/scripts/packages"

HOME_DIR="$HOME"
BASHRC_FILE="$HOME_DIR/.bashrc"

GIT_FULL_NAME="Aditya Azad"
GIT_EMAIL="adityaazad121@gmail.com"

require_user() {
  [[ "$1" == "$(id -un)" ]] || { echo "run as '$1' (you are '$(id -un)')" >&2; exit 1; }
}

pkg_has() { pacman -Qi "$1" >/dev/null 2>&1; }
