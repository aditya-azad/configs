#!/bin/bash

set -e

BASHRC_FILE="$HOME/.bashrc"

# prompt
echo "PS1='\[\e[38;5;28m\]\u@\h:\w\[\e[0m\]$ '" >> "$BASHRC_FILE"

# directories
echo "alias cdw='cd ~/database/workspace'" >> "$BASHRC_FILE"

# utils
echo "alias cat='bat'" >> "$BASHRC_FILE"

# documents
echo "alias todo='nvim ~/database/workspace/inbox.md'" >> "$BASHRC_FILE"
echo "alias ideas='nvim ~/database/workspace/ideas.md'" >> "$BASHRC_FILE"

# robotics
echo "alias qgc='QGroundControl-x86_64.AppImage'" >> "$BASHRC_FILE"

# ssh
echo "alias e1='ssh -Y eagle1@eagle1'" >> "$BASHRC_FILE"
echo "alias e1j='ssh -Y eagle1@jetson'" >> "$BASHRC_FILE"
echo "alias e3='ssh -Y eagle3@eagle3'" >> "$BASHRC_FILE"
echo "alias e3j='ssh -Y eagle3@jetson'" >> "$BASHRC_FILE"
echo "alias e7='ssh -Y eagle7@eagle7'" >> "$BASHRC_FILE"
echo "alias e7j='ssh -Y eagle7@jetson'" >> "$BASHRC_FILE"
echo "alias tur='ssh -Y aazad@turing.wpi.edu'" >> "$BASHRC_FILE"

# diary
cat <<'EOF' >> ~/.bashrc

diary() {
    local notes_dir="$HOME/database/workspace/diary"
    local today
    today=$(date +"%Y-%m-%d")
    local file="$notes_dir/$today.md"

    # Create the file if it doesn't exist
    if [[ ! -f "$file" ]]; then
        touch "$file"
    fi

    # Open with your preferred editor
    nvim "$file"
}
EOF

# ros domain id modifier
START="# >>> rdid function >>>"
END="# <<< rdid function <<<"

RDID_FUNC_CONTENT='
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

  if grep -qE "^[[:space:]]*export[[:space:]]+ROS_DOMAIN_ID=" "$bashrc"; then
    sed -i -E "s|^[[:space:]]*export[[:space:]]+ROS_DOMAIN_ID=.*|$line|" "$bashrc"
  else
    printf "\n%s\n" "$line" >> "$bashrc"
  fi

  echo "ROS_DOMAIN_ID set to ${id} (current shell) and persisted in ~/.bashrc"
}
'

# Remove any existing block between markers (if present)
if grep -qF "$START" "$BASHRC_FILE"; then
  awk -v start="$START" -v end="$END" '
    BEGIN {inblock=0}
    $0 ~ start {inblock=1; next}
    $0 ~ end {inblock=0; next}
    inblock==0 {print}
  ' "$BASHRC_FILE" > "${BASHRC_FILE}.tmp"
  mv "${BASHRC_FILE}.tmp" "$BASHRC_FILE"
fi

# Append the fresh block
{
  printf "\n%s\n" "$START"
  printf "%s\n" "$RDID_FUNC_CONTENT"
  printf "%s\n" "$END"
} >> "$BASHRC_FILE"
