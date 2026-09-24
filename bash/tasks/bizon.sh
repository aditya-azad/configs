#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

lineinfile --sudo /etc/hosts '^\s*130\.215\.183\.33\s+bizon\s*$' "130.215.183.33 bizon"

blockinfile "$BASHRC_FILE" "bizon-ssh" <<EOF
alias bizon='ssh -Y ${BIZON_USER}@bizon'
EOF
