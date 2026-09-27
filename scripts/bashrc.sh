#!/usr/bin/env bash
set -euo pipefail

BASHRC_FILE="/home/$(id -un)/.bashrc"

touch "$BASHRC_FILE"

ROS_DOMAIN_ID=0
PX4_PATH="/home/$(id -un)/code/PX4-Autopilot"

sed -i '/# BEGIN configs bashrc/,/# END configs bashrc/d' "$BASHRC_FILE"
cat >> "$BASHRC_FILE" <<'EOF'
# BEGIN configs bashrc
alias brc='nvim ~/.bashrc'

case ":$PATH:" in
  *:"$HOME/.local/bin":*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

alias cdc='cd ~/code'
alias cdd='cd ~/Downloads'
alias cdw='cd ~/database/workspace'
alias conf='cd ~/.config && nvim'

alias todo='nvim ~/database/workspace/diary/todo.md'
alias ideas='nvim ~/database/workspace/diary/ideas.md'
alias notes='cd ~/database/workspace/notes && nvim'

[ -f "$HOME/.local/lib/venvup" ] && source "$HOME/.local/lib/venvup"
[ -f "$HOME/.local/lib/rdid" ]   && source "$HOME/.local/lib/rdid"

alias z='zellij'
alias tmux='zellij'
alias scp='rsync -avP'

alias vim='nvim'
alias vi='nvim'
export EDITOR=nvim

set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

alias qgc='QGroundControl-x86_64.AppImage'
alias r2='source /opt/ros/humble/setup.bash'
alias ws='source ./install/setup.bash'
alias cws='rm -rf ./build ./install ./log'
alias bws='colcon build --symlink-install'
alias acp='source ~/code/acp_ws/install/setup.bash'

alias e7='ssh -Y eagle7@eagle7'
alias e7j='ssh -Y eagle7@jetson'

export ROS_LOCALHOST_ONLY=0
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export PX4_PATH=$PX4_PATH
export ROS_DOMAIN_ID=$ROS_DOMAIN_ID

alias chrons='chronyc sources'
alias chronr='sudo systemctl restart chronyd'
alias chronc='sudo nvim /etc/chrony/chrony.conf'

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

venvup() {
  local dir="$PWD"
  local home="${HOME%/}"
  local name
  while true; do
    for name in .venv venv; do
      if [ -f "$dir/$name/bin/activate" ]; then
        source "$dir/$name/bin/activate"
        echo "Activated: $dir/$name"
        return 0
      fi
    done
    if [ "$dir" = "$home" ] || [ "$dir" = "/" ]; then
      break
    fi
    dir="$(dirname "$dir")"
  done
  echo "No .venv or venv found from $PWD up to $home" >&2
  return 1
}

# END configs bashrc
EOF
