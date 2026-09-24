#!/usr/bin/env bash
set -euo pipefail
# Provision one host according to its selected programs.
# Usage: bash setup.sh <host>   (e.g. legion7i | eagle)
# Run as the managed user (NOT root); the sudo password is prompted once.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/lib/common.sh"

log()  { printf '\033[1;34m::\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }

[[ "${EUID:-$(id -u)}" -ne 0 ]] || { echo "xx run as the managed user, not root (do NOT prefix with sudo): bash setup.sh <host>" >&2; exit 1; }

HOST="${1:-}"
[[ -n "$HOST" ]] || { echo "usage: bash setup.sh <host>  (e.g. legion7i | eagle)" >&2; exit 1; }
ENVFILE="$SCRIPT_DIR/hosts/$HOST.env"
[[ -f "$ENVFILE" ]] || { echo "xx no host env file: $ENVFILE" >&2; exit 1; }

. "$ENVFILE"
init_host "$USERNAME"

log "Provisioning host '$HOST' as user '$USERNAME'"
sudo -v
( while true; do sudo -n -v 2>/dev/null || true; sleep 50; done ) &
KA=$!
trap 'kill "$KA" 2>/dev/null || true' EXIT

# --- pre-tasks (mirror ansible/playbooks/site.yml) --------------------------
mkdir -p "$CODE_DIR" "$SOFTWARE_DIR"
chmod 0755 "$CODE_DIR" "$SOFTWARE_DIR"

log "pre-task: ssh_key"; . "$TASKS_DIR/ssh_key.sh"
log "pre-task: git";     . "$TASKS_DIR/git.sh"
log "pre-task: rust";    . "$TASKS_DIR/rust.sh"

# --- selected programs ------------------------------------------------------
current_task=""
trap 'kill "$KA" 2>/dev/null || true; [[ -n "$current_task" ]] && warn "FAILED in program: $current_task"' ERR

for prog in "${programs[@]}"; do
  current_task="$prog"
  task="$TASKS_DIR/$prog.sh"
  if [[ -f "$task" ]]; then
    log "program: $prog"
    bash "$task"
  else
    warn "no task file for program '$prog' (expected $task) — skipping"
  fi
  current_task=""
done

trap - ERR
kill "$KA" 2>/dev/null || true
trap - EXIT
log "provisioning complete"
