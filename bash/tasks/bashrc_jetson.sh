#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

touch "$BASHRC_FILE"

blockinfile "$BASHRC_FILE" "jetson-prompt" <<'EOF'
PS1='\[\e[38;5;196m\]\u@\h\[\e[38;5;28m\]:\w\[\e[0m\]\$ '
EOF

blockinfile "$BASHRC_FILE" "jetson-robotics" <<'EOF'
alias sin='sudo chmod 666 /dev/ttyTHS1 && singularity exec --nv -B /run ~/code/singularity/jetson_6_2.sif /bin/bash'
alias fan='sudo jetson_clocks --fan'
EOF

lineinfile "$BASHRC_FILE" '^\s*export\s+ROS_DOMAIN_ID=[0-9]+$' "export ROS_DOMAIN_ID=$ROS_DOMAIN_ID"
