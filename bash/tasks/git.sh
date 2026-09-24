#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

git config --global user.name  "$GIT_FULL_NAME"
git config --global user.email "$GIT_EMAIL"

bash -c 'eval "$(ssh-agent -s)"; ssh-add "$HOME/.ssh/id_ed25519" 2>/dev/null || true' || true
