#!/usr/bin/env bash

CONFIGS_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PACKAGES_DIR="$CONFIGS_REPO/bash/packages"
TASKS_DIR="$CONFIGS_REPO/bash/tasks"

USERNAME="$(id -un)"
HOME_DIR="$(getent passwd "$USERNAME" | cut -d: -f6)"
HOME="$HOME_DIR"
USER_UID="$(id -u)"
XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$USER_UID}"
DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=$XDG_RUNTIME_DIR/bus}"
CODE_DIR="$HOME_DIR/code"
SOFTWARE_DIR="$HOME_DIR/.software"
BASHRC_FILE="$HOME_DIR/.bashrc"
MISE_BIN="$HOME_DIR/.local/bin/mise"
CARGO_BIN="$HOME_DIR/.cargo/bin"
ARCH="$(uname -m)"
KERNEL="$(uname -r)"
NPROC="$(nproc)"

if [[ -f /etc/os-release ]]; then
  UBUNTU_CODENAME="$(. /etc/os-release && echo "${VERSION_CODENAME:-noble}")"
else
  UBUNTU_CODENAME="noble"
fi

export CONFIGS_REPO PACKAGES_DIR TASKS_DIR USERNAME HOME_DIR HOME USER_UID \
       XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS CODE_DIR SOFTWARE_DIR BASHRC_FILE \
       MISE_BIN CARGO_BIN ARCH KERNEL NPROC UBUNTU_CODENAME
