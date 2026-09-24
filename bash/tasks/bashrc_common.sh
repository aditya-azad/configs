#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

touch "$BASHRC_FILE"

sed -i '/# BEGIN configs bashrc-common/,/# END configs bashrc-common/d' "$BASHRC_FILE"
cat >> "$BASHRC_FILE" <<'EOF'
# BEGIN configs bashrc-common
alias start='xdg-open'
alias brc='nvim ~/.bashrc'
alias dev='./scripts/dev.sh'

case ":$PATH:" in
  *:"$HOME/.local/bin":*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

alias cdc='cd ~/code'
alias cdd='cd ~/Downloads'

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

export PATH=${PATH}:/usr/src/tensorrt/bin/
alias r2='source /opt/ros/humble/setup.bash'
alias ws='source ./install/setup.bash'
alias cws='rm -rf ./build ./install ./log'
alias bws='colcon build --symlink-install'
alias chrons='chronyc sources'
alias chronr='sudo systemctl restart chronyd'
alias chronc='sudo nvim /etc/chrony/chrony.conf'
alias acp='source ~/code/acp_ws/install/setup.bash'
export ROS_LOCALHOST_ONLY=0
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

eval "$(~/.local/bin/mise activate bash)"
# END configs bashrc-common
EOF
