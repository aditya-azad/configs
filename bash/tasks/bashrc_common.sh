#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

touch "$BASHRC_FILE"

blockinfile "$BASHRC_FILE" "common-system-shortcuts" <<'EOF'
alias start='xdg-open'
alias brc='nvim ~/.bashrc'
alias dev='./scripts/dev.sh'
EOF

blockinfile "$BASHRC_FILE" "common-local-bin-path" <<'EOF'
case ":$PATH:" in
  *:"$HOME/.local/bin":*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
EOF

blockinfile "$BASHRC_FILE" "common-directories" <<'EOF'
alias cdc='cd ~/code'
alias cdd='cd ~/Downloads'
EOF

blockinfile "$BASHRC_FILE" "common-helpers" <<'EOF'
[ -f "$HOME/.local/lib/venvup" ] && source "$HOME/.local/lib/venvup"
[ -f "$HOME/.local/lib/rdid" ]   && source "$HOME/.local/lib/rdid"
EOF

blockinfile "$BASHRC_FILE" "common-utils" <<'EOF'
alias z='zellij'
alias tmux='zellij'
alias scp='rsync -avP'
EOF

blockinfile "$BASHRC_FILE" "common-editor" <<'EOF'
alias vim='nvim'
alias vi='nvim'
export EDITOR=nvim
EOF

blockinfile "$BASHRC_FILE" "common-vi-bindings" <<'EOF'
set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'
EOF

blockinfile "$BASHRC_FILE" "common-robotics" <<'EOF'
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
EOF

blockinfile "$BASHRC_FILE" "common-mise" <<'EOF'
eval "$(~/.local/bin/mise activate bash)"
EOF
