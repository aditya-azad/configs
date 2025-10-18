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

