#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

touch "$BASHRC_FILE"

sed -i '/# BEGIN configs bashrc-jetson/,/# END configs bashrc-jetson/d' "$BASHRC_FILE"
cat >> "$BASHRC_FILE" <<EOF
# BEGIN configs bashrc-jetson
PS1='\[\e[38;5;196m\]\u@\h\[\e[38;5;28m\]:\w\[\e[0m\]\$ '
alias sin='sudo chmod 666 /dev/ttyTHS1 && singularity exec --nv -B /run ~/code/singularity/jetson_6_2.sif /bin/bash'
alias fan='sudo jetson_clocks --fan'
export ROS_DOMAIN_ID=$ROS_DOMAIN_ID
# END configs bashrc-jetson
EOF
