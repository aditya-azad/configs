#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/lib/common.sh"

HOST="${1:-}"
[[ -n "$HOST" ]] || { echo "usage: bash setup.sh <host>  (e.g. legion7i | eagle)" >&2; exit 1; }
ENVFILE="$SCRIPT_DIR/hosts/$HOST.env"
[[ -f "$ENVFILE" ]] || { echo "no host env file: $ENVFILE" >&2; exit 1; }
set -a; . "$ENVFILE"; set +a
[[ "$USERNAME" == "$(id -un)" ]] || { echo "host '$HOST' expects user '$USERNAME' but you are '$(id -un)'; run as '$USERNAME'" >&2; exit 1; }

mkdir -p "$CODE_DIR" "$SOFTWARE_DIR"

bash "$TASKS_DIR/ssh_key.sh"
bash "$TASKS_DIR/git.sh"
bash "$TASKS_DIR/rust.sh"

for prog in "${programs[@]}"; do
  task="$TASKS_DIR/$prog.sh"
  if [[ -f "$task" ]]; then
    echo ":: $prog"
    bash "$task"
  else
    echo "!! no task for $prog (expected $task) — skipping" >&2
  fi
done
