#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

touch "$BASHRC_FILE"

blockinfile "$BASHRC_FILE" "desktop-prompt" <<'EOF'
PS1='\[\e[38;5;28m\]\u@\h:\w\[\e[0m\]$ '
EOF

blockinfile "$BASHRC_FILE" "desktop-directories" <<'EOF'
alias cdw='cd ~/database/workspace'
EOF

blockinfile "$BASHRC_FILE" "desktop-documents" <<'EOF'
alias todo='nvim ~/database/workspace/inbox.md'
alias ideas='nvim ~/database/workspace/ideas.md'
alias notes='nvim ~/database/workspace/notes'
EOF

blockinfile "$BASHRC_FILE" "desktop-robotics" <<EOF
alias qgc='QGroundControl-x86_64.AppImage'
export PX4_PATH=$PX4_PATH
EOF

blockinfile "$BASHRC_FILE" "desktop-ssh" <<'EOF'
alias e7='ssh -Y eagle7@eagle7'
alias e7j='ssh -Y eagle7@jetson'
EOF

blockinfile "$BASHRC_FILE" "desktop-rdid >>> block >>>" <<'EOF'
# Usage: rdid 23
# Sets ROS_DOMAIN_ID in current shell and persists it in ~/.bashrc
rdid() {
  if [ -z "${1-}" ]; then
    echo "Usage: rdid <domain_id>" >&2
    return 2
  fi

  case "$1" in
    ""|*[!0-9]*)
      echo "Error: domain_id must be a non-negative integer." >&2
      return 2
      ;;
    *)
      if [ "$1" -gt 232 ] 2>/dev/null; then
        echo "Warning: domain_id > 232 may be unsupported by some ROS 2 setups." >&2
      fi
      ;;
  esac

  local id="$1"
  local bashrc="$HOME/.bashrc"
  local line="export ROS_DOMAIN_ID=${id}"

  export ROS_DOMAIN_ID="$id"

  if grep -qE "^[[:space:]]*export[[:space:]]+ROS_DOMAIN_ID=[0-9]+" "$bashrc"; then
    sed -i.bak -E "s|^[[:space:]]*export[[:space:]]+ROS_DOMAIN_ID=[0-9]+$|$line|" "$bashrc"
  else
    printf "\n%s\n" "$line" >> "$bashrc"
  fi

  echo "ROS_DOMAIN_ID set to ${id} (current shell) and persisted in ~/.bashrc"
}
EOF

lineinfile "$BASHRC_FILE" '^\s*export\s+ROS_DOMAIN_ID=[0-9]+$' "export ROS_DOMAIN_ID=$ROS_DOMAIN_ID"
