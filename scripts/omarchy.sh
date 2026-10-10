#!/usr/bin/env bash

# All-in-one setup for omarchy
set -euo pipefail

# ---------------------------------------------------------------- env / setup

mkdir -p "$HOME_DIR/.local/bin"
chmod 0755 "$HOME_DIR/.local/bin"

CONFIGS_REPO="$HOME/.config"
PACKAGES_DIR="$CONFIGS_REPO/scripts/packages"

USERNAME="azada"
GIT_FULL_NAME="Aditya Azad"
GIT_EMAIL="adityaazad121@gmail.com"
ROS_DOMAIN_ID=0
PX4_PATH="$HOME/code/PX4-Autopilot"

[[ "$USERNAME" == "$(id -un)" ]] || { echo "run as '$USERNAME' (you are '$(id -un)')" >&2; exit 1; }

HOME_DIR="$HOME"
BASHRC_FILE="$HOME_DIR/.bashrc"

# ---------------------------------------------------------------- firacode

omarchy pkg add ttf-firacode-nerd

# ---------------------------------------------------------------- steam

sudo omarchy-pkg-add steam

# ---------------------------------------------------------------- keepass

sudo pacman -Sy keepassxc

# ---------------------------------------------------------------- freefilesync

yay -S freefilesync-bin

# ---------------------------------------------------------------- zellij

sudo pacman -Sy zellij

# ---------------------------------------------------------------- hugo

sudo pacman -S hugo

# ---------------------------------------------------------------- anki

sudo pacman -S anki

# ---------------------------------------------------------------- global protect

yay -S globalprotect-openconnect

# ---------------------------------------------------------------- nvidia container toolkit (docker gpu)

sudo pacman -S nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# ---------------------------------------------------------------- pi

curl -fsSL https://pi.dev/install.sh | sh

cfg="$HOME_DIR/.pi/agent/settings.json"

cat > "$cfg" <<'EOF'
{
  "theme": "omarchy-system",
  "packages": [
    "npm:pi-subagents",
    "npm:@zhushanwen/pi-ask-user",
    "npm:pi-agent-browser-native",
    "npm:pi-mcp-adapter",
    "npm:pi-notify",
    "npm:pi-vim"
  ],
  "defaultProvider": "openrouter",
  "defaultModel": "z-ai/glm-5.3-flash"
}
EOF

# ---------------------------------------------------------------- wpi-vpn

ln -sfn "$PACKAGES_DIR/wpi-vpn/wpi-vpn" "$HOME_DIR/.local/bin/wpi-vpn"

# ---------------------------------------------------------------- macos container (start-mac)

ln -sfn "$PACKAGES_DIR/start-mac/start-mac" "$HOME_DIR/.local/bin/start-mac"

# ---------------------------------------------------------------- distrobox launcher (db)

ln -sfn "$PACKAGES_DIR/distrobox/db" "$HOME_DIR/.local/bin/db"

# ---------------------------------------------------------------- github backup (ghclone)

ln -sfn "$PACKAGES_DIR/ghclone/ghclone" "$HOME_DIR/.local/bin/ghclone"

# ---------------------------------------------------------------- bashrc

touch "$BASHRC_FILE"

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

alias bizon='ssh -Y aazad@bizon'

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

# ---------------------------------------------------------------- hosts

update_host() {
  local ip="$1" name="$2"
  if grep -qE "^[[:space:]]*${ip}[[:space:]]+${name}[[:space:]]*$" /etc/hosts; then
    sudo sed -i -E "s|^[[:space:]]*${ip}[[:space:]]+${name}[[:space:]]*$|${ip} ${name}|" /etc/hosts
  else
    echo "${ip} ${name}" | sudo tee -a /etc/hosts >/dev/null
  fi
}

# Add hosts from ~/code/configs (bizon, jetson) to /etc/hosts, idempotently.
update_host "192.168.55.1" "jetson"
update_host "130.215.183.33" "bizon"

echo "hosts updated:"
grep -E "jetson|bizon" /etc/hosts
