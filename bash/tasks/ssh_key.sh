#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

mkdir -p "$HOME_DIR/.ssh"
chmod 0700 "$HOME_DIR/.ssh"

if [[ ! -f "$HOME_DIR/.ssh/id_ed25519" ]]; then
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$HOME_DIR/.ssh/id_ed25519" -N ""
  echo
  echo "!! A new SSH key was generated for '$USERNAME' ($HOME_DIR/.ssh/id_ed25519)." >&2
  echo "!! Add this public key to GitHub: Settings -> SSH and GPG keys -> New SSH key:" >&2
  echo
  cat "$HOME_DIR/.ssh/id_ed25519.pub"
  echo
  read -rp "Paste the public key above into GitHub, then press Enter to continue (Ctrl+C to abort): "
fi
