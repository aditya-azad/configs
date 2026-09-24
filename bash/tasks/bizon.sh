#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

if sudo grep -qE '^\s*130\.215\.183\.33\s+bizon\s*$' /etc/hosts; then
  sudo sed -i -E 's|^\s*130\.215\.183\.33\s+bizon\s*$|130.215.183.33 bizon|' /etc/hosts
else
  echo "130.215.183.33 bizon" | sudo tee -a /etc/hosts >/dev/null
fi

sed -i '/# BEGIN configs bizon-ssh/,/# END configs bizon-ssh/d' "$BASHRC_FILE"
cat >> "$BASHRC_FILE" <<EOF
# BEGIN configs bizon-ssh
alias bizon='ssh -Y ${BIZON_USER}@bizon'
# END configs bizon-ssh
EOF
