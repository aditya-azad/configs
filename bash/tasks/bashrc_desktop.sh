#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

touch "$BASHRC_FILE"

sed -i '/# BEGIN configs bashrc-desktop/,/# END configs bashrc-desktop/d' "$BASHRC_FILE"
cat >> "$BASHRC_FILE" <<EOF
# BEGIN configs bashrc-desktop
PS1='\[\e[38;5;28m\]\u@\h:\w\[\e[0m\]\$ '
alias cdw='cd ~/database/workspace'
alias todo='nvim ~/database/workspace/diary/todo.md'
alias ideas='nvim ~/database/workspace/diary/ideas.md'
alias notes='nvim ~/database/workspace/notes'
alias qgc='QGroundControl-x86_64.AppImage'
export PX4_PATH=$PX4_PATH
export ROS_DOMAIN_ID=$ROS_DOMAIN_ID
alias e7='ssh -Y eagle7@eagle7'
alias e7j='ssh -Y eagle7@jetson'

# Usage: rdid 23
# Sets ROS_DOMAIN_ID in current shell and persists it in ~/.bashrc
rdid() {
  if [ -z "\${1-}" ]; then
    echo "Usage: rdid <domain_id>" >&2
    return 2
  fi

  case "\$1" in
    ""|*[!0-9]*)
      echo "Error: domain_id must be a non-negative integer." >&2
      return 2
      ;;
    *)
      if [ "\$1" -gt 232 ] 2>/dev/null; then
        echo "Warning: domain_id > 232 may be unsupported by some ROS 2 setups." >&2
      fi
      ;;
  esac

  local id="\$1"
  local bashrc="\$HOME/.bashrc"
  local line="export ROS_DOMAIN_ID=\${id}"

  export ROS_DOMAIN_ID="\$id"

  if grep -qE "^[[:space:]]*export[[:space:]]+ROS_DOMAIN_ID=[0-9]+" "\$bashrc"; then
    sed -i.bak -E "s|^[[:space:]]*export[[:space:]]+ROS_DOMAIN_ID=[0-9]+\$|\$line|" "\$bashrc"
  else
    printf "\n%s\n" "\$line" >> "\$bashrc"
  fi

  echo "ROS_DOMAIN_ID set to \${id} (current shell) and persisted in ~/.bashrc"
}
# END configs bashrc-desktop
EOF
