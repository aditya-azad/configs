#!/bin/bash

set -e

BASHRC_FILE="$HOME/.bashrc"

# prompt
echo "PS1='\[\e[38;5;196m\]\u@\h\[\e[38;5;28m\]:\w\[\e[0m\]\$ '" >> "$BASHRC_FILE"

# robotics
echo "alias sin='singularity exec --nv -B /run ~/code/singularity/jetson_6_2.sif /bin/bash'" >> "$BASHRC_FILE"
echo "alias acp='source ~/code/acp_ws/install/setup.bash'" >> "$BASHRC_FILE"
echo "alias fan='sudo jetson_clocks --fan'" >> "$BASHRC_FILE"

