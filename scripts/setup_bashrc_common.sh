#!/bin/bash

set -e

BASHRC_FILE="$HOME/.bashrc"

# system shortcuts
echo "alias start='xdg-open'" >> "$BASHRC_FILE"
echo "alias brc='nvim ~/.bashrc'" >> "$BASHRC_FILE"
echo "alias st='~/code/configs/scripts/switch_theme.sh'" >> "$BASHRC_FILE"
echo "alias dev='./scripts/dev.sh'" >> "$BASHRC_FILE"

# directories
echo "alias cdc='cd ~/code'" >> "$BASHRC_FILE"
echo "alias cdd='cd ~/Downloads'" >> "$BASHRC_FILE"

# python
echo "alias sv='source ./venv/bin/activate'" >> "$BASHRC_FILE"
echo "alias svd='source ./.venv/bin/activate'" >> "$BASHRC_FILE"

# utils
echo "alias z='zellij'" >> "$BASHRC_FILE"
echo "alias tmux='zellij'" >> "$BASHRC_FILE"
echo "alias scp='rsync -avP'" >> "$BASHRC_FILE"
echo "alias du='dust'" >> "$BASHRC_FILE"
echo "alias ls='eza'" >> "$BASHRC_FILE"

# editor
echo "alias vim='nvim'" >> "$BASHRC_FILE"
echo "alias vi='nvim'" >> "$BASHRC_FILE"
echo "export EDITOR=nvim" >> "$BASHRC_FILE"

# vim bindings
echo "set -o vi" >> "$BASHRC_FILE"
echo "bind -m vi-command 'Control-l: clear-screen'" >> "$BASHRC_FILE"
echo "bind -m vi-insert 'Control-l: clear-screen'" >> "$BASHRC_FILE"

# robotics
echo 'export PATH=${PATH}:/usr/src/tensorrt/bin/' >> "$BASHRC_FILE"
echo "alias r2='source /opt/ros/humble/setup.bash'" >> "$BASHRC_FILE"
echo "alias ws='source ./install/setup.bash'" >> "$BASHRC_FILE"
echo "alias cws='rm -rf ./build ./install ./log'" >> "$BASHRC_FILE"
echo "alias bws='colcon build --symlink-install'" >> "$BASHRC_FILE"
echo "alias chrons='chronyc sources'" >> "$BASHRC_FILE"
echo "alias chronr='sudo systemctl restart chronyd'" >> "$BASHRC_FILE"
echo "alias chronc='sudo nvim /etc/chrony/chrony.conf'" >> "$BASHRC_FILE"
echo "alias acp='source ~/code/acp_ws/install/setup.bash'" >> "$BASHRC_FILE"
echo "export ROS_LOCALHOST_ONLY=0" >> "$BASHRC_FILE"
echo "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp" >> "$BASHRC_FILE"

# mise
echo 'eval "$(~/.local/bin/mise activate bash)"' >> "$BASHRC_FILE"
