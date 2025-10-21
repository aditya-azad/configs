#!/bin/bash

set -e

BASHRC_FILE="$HOME/.bashrc"

# prompt
echo "PS1='\[\e[38;5;196m\]\u@\h\[\e[38;5;28m\]:\w\[\e[0m\]\$ '" >> "$BASHRC_FILE"

# robotics
echo "alias sin='singularity exec --nv -B /run ~/code/singularity/jetson_6_2.sif /bin/bash'" >> "$BASHRC_FILE"
echo "alias acp='source ~/code/acp_ws/install/setup.bash'" >> "$BASHRC_FILE"
echo "alias fan='sudo jetson_clocks --fan'" >> "$BASHRC_FILE"

read -rp "Enter ROS_DOMAIN_ID [0-101] (default 0): " ROS_DOMAIN_ID_INPUT
ROS_DOMAIN_ID_INPUT=${ROS_DOMAIN_ID_INPUT:-0}
if ! [[ "$ROS_DOMAIN_ID_INPUT" =~ ^[0-9]+$ ]]; then
  echo "Error: ROS_DOMAIN_ID must be an integer." >&2
  exit 1
fi
if (( ROS_DOMAIN_ID_INPUT < 0 || ROS_DOMAIN_ID_INPUT > 101 )); then
  echo "Error: ROS_DOMAIN_ID must be between 0 and 101 inclusive." >&2
  exit 1
fi
echo "export ROS_DOMAIN_ID=${ROS_DOMAIN_ID_INPUT}" >> "$BASHRC_FILE"

echo "export ROS_LOCALHOST_ONLY=0" >> "$BASHRC_FILE"
echo "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp" >> "$BASHRC_FILE"
