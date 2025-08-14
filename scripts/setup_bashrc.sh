#!/bin/bash

BASHRC_FILE="$HOME/.bashrc"

# shortcuts
echo "alias sdn='shutdown now'" >> "$BASHRC_FILE"
echo "alias start='xdg-open'" >> "$BASHRC_FILE"

# editor
echo "alias vim='nvim'" >> "$BASHRC_FILE"
echo "alias vi='nvim'" >> "$BASHRC_FILE"
echo "export EDITOR=nvim" >> "$BASHRC_FILE"

# vim bindings
echo "set -o vi" >> "$BASHRC_FILE"
echo "bind -m vi-command 'Control-l: clear-screen'" >> "$BASHRC_FILE"
echo "bind -m vi-insert 'Control-l: clear-screen'" >> "$BASHRC_FILE"

# documents
echo "alias todo='nvim ~/database/workspace/inbox.md'" >> "$BASHRC_FILE"
echo "alias ideas='nvim ~/database/workspace/ideas.md'" >> "$BASHRC_FILE"

# robotics
echo 'export PATH=${PATH}:/usr/src/tensorrt/bin/' >> "$BASHRC_FILE"
echo "alias r2='source /opt/ros/humble/setup.bash'" >> "$BASHRC_FILE"
echo "alias ws='source ./install/setup.bash'" >> "$BASHRC_FILE"
echo "alias cws='rm -rf ./build ./install ./log'" >> "$BASHRC_FILE"
echo "alias bws='colcon build --symlink-install'" >> "$BASHRC_FILE"

# git
echo "alias gpl='git pull'" >> "$BASHRC_FILE"
echo "alias gp='git push'" >> "$BASHRC_FILE"
echo "alias gc='git commit -m '" >> "$BASHRC_FILE"
echo "alias ga='git add .'" >> "$BASHRC_FILE"
echo "gacp() { git add . && git commit -m \"\$1\" && git push; }" >> "$BASHRC_FILE"
