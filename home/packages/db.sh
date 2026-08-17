#!/usr/bin/env bash
# db.sh — distrobox launcher body. The BOXES assoc array is injected by the
# derivation (db.nix) from the flake's container registry.
#
#   db               list every box with created status + active marker
#   db <name>        create (if absent) + enter the container with GPU passthrough
#   db -h            usage
# Unknown name -> error + list available boxes.

set -euo pipefail

usage() {
  cat <<EOF
Usage: db [name]
  No args   — list all distrobox containers in the registry.
  <name>    — create (if absent, with --nvidia) and enter the container.
  -h        — this help.

Known boxes:
EOF
  for n in "''${!BOXES[@]}"; do
    echo "  $n  $''{BOXES[$n]}"
  done
}

list_boxes() {
  # Snapshot of existing containers: name -> image.
  local -A created=()
  local row name img
  while IFS=$'\t' read -r name img; do
    [ -n "$name" ] && created["$name"]="$img"
  done < <(distrobox list | jq -r '.[] | [.name, .image] | @tsv' 2>/dev/null || true)

  # Best-effort active-box detection: distrobox list marks the running one.
  local active=""
  active="$(distrobox list | jq -r 'first(.[] | select(.status=="running")) | .name' 2>/dev/null || true)"

  for n in $(printf '%s\n' "''${!BOXES[@]}" | sort); do
    local mark=" "
    [ "$n" = "$active" ] && mark="*"
    if [ -n "''${created[$n]+x}" ]; then
      printf '%-14s [created]   %s  %s\n' "$n" "''${BOXES[$n]}" "$mark"
    else
      printf '%-14s [—]         %s  %s\n' "$n" "''${BOXES[$n]}" "$mark"
    fi
  done
}

enter_box() {
  local name="$1"
  if [ -z "''${BOXES[$name]+x}" ]; then
    echo "db: unknown box '$name'" >&2
    echo "Available boxes:" >&2
    for n in $(printf '%s\n' "''${!BOXES[@]}" | sort); do
      echo "  $n" >&2
    done
    return 1
  fi

  local image="''${BOXES[$name]}"
  local ini="$HOME/code/configs-nix/containers/$name/distrobox.ini"

  # Create only if not present.
  if ! distrobox list | jq -e --arg n "$name" '.[].name == $n' >/dev/null 2>&1; then
    echo "db: creating '$name' from '$image' (nvidia passthrough)…"
    local create_args=(create --name "$name" --image "$image" --nvidia)
    [ -f "$ini" ] && create_args+=(--additional-flags "--config=$ini")
    distrobox "''${create_args[@]}"
  fi
  exec distrobox enter "$name"
}

main() {
  case "''${1:-}" in
    -h|--help) usage; exit 0 ;;
    "")        list_boxes ;;
    *)         enter_box "$1" ;;
  esac
}

main "$@"
