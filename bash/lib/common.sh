#!/usr/bin/env bash
# Shared environment variables for the bash provisioning layer.
# Sourced by setup.sh and by every tasks/<name>.sh. Do not execute directly.

CONFIGS_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PACKAGES_DIR="$CONFIGS_REPO/ansible/files/packages"
TASKS_DIR="$CONFIGS_REPO/bash/tasks"

ARCH="$(uname -m)"
KERNEL="$(uname -r)"
NPROC="$(nproc)"
if [[ -f /etc/os-release ]]; then
  UBUNTU_CODENAME="$(. /etc/os-release && echo "${VERSION_CODENAME:-noble}")"
else
  UBUNTU_CODENAME="noble"
fi

export CONFIGS_REPO PACKAGES_DIR TASKS_DIR ARCH KERNEL NPROC UBUNTU_CODENAME

# Resolve the managed user + derived paths from the current (non-root) session.
init_host() {
  local env_user="${1:-}"
  local cur_user; cur_user="$(id -un)"
  if [[ -n "$env_user" && "$env_user" != "$cur_user" ]]; then
    echo "xx host env expects user '$env_user' but you are '$cur_user'; run as '$env_user'" >&2
    exit 1
  fi
  USERNAME="$cur_user"
  HOME_DIR="$(getent passwd "$USERNAME" | cut -d: -f6)"
  export HOME="$HOME_DIR"
  USER_UID="$(id -u)"
  XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$USER_UID}"
  DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=$XDG_RUNTIME_DIR/bus}"
  CODE_DIR="$HOME_DIR/code"
  SOFTWARE_DIR="$HOME_DIR/.software"
  BASHRC_FILE="$HOME_DIR/.bashrc"
  MISE_BIN="$HOME_DIR/.local/bin/mise"
  CARGO_BIN="$HOME_DIR/.cargo/bin"
  : "${NVIDIA_DRIVER_VERSION:=580}"
  : "${BIZON_USER:=aazad}"
  export USERNAME HOME_DIR USER_UID XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS \
         CODE_DIR SOFTWARE_DIR BASHRC_FILE MISE_BIN CARGO_BIN \
         NVIDIA_DRIVER_VERSION BIZON_USER
}

# Idempotency primitive mandated by AGENTS.md (marker `# {mark} ANSIBLE …`).
# Optional leading "--sudo" writes a root-owned file via sudo.
# Usage: blockinfile [--sudo] <file> <marker> <<'EOF' ... EOF
blockinfile() {
  local sudo=0
  [[ "${1:-}" == "--sudo" ]] && { sudo=1; shift; }
  local file="$1" marker="$2"; shift 2
  local begin="# BEGIN ANSIBLE $marker"
  local end="# END ANSIBLE $marker"
  local tmp; tmp=$(mktemp)
  if [[ -f "$file" ]]; then
    awk -v b="$begin" -v e="$end" '
      $0==b { f=1; next }
      $0==e { f=0; next }
      !f { print }
    ' "$file" > "$tmp" 2>/dev/null || : > "$tmp"
  fi
  {
    printf '%s\n' "$begin"
    cat
    printf '%s\n' "$end"
  } >> "$tmp"
  if [[ $sudo == 1 ]]; then
    sudo tee "$file" > /dev/null < "$tmp"
  else
    cat "$tmp" > "$file"
  fi
  rm -f "$tmp"
}

# Ensure a line matching `regexp` exists exactly once, set to `line`.
# Usage: lineinfile [--sudo] <file> <regexp> <line>
lineinfile() {
  local sudo=0
  [[ "${1:-}" == "--sudo" ]] && { sudo=1; shift; }
  local file="$1" regexp="$2" line="$3"
  local tmp; tmp=$(mktemp)
  if [[ -f "$file" ]]; then
    REPL="$line" perl -ne 'if (/'"$regexp"'/) { print $ENV{REPL} . "\n" } else { print }' "$file" > "$tmp" 2>/dev/null || cp "$file" "$tmp" 2>/dev/null || : > "$tmp"
  fi
  if ! grep -Pq "$regexp" "$tmp" 2>/dev/null; then
    printf '%s\n' "$line" >> "$tmp"
  fi
  if [[ $sudo == 1 ]]; then
    sudo tee "$file" > /dev/null < "$tmp"
  else
    cat "$tmp" > "$file"
  fi
  rm -f "$tmp"
}
