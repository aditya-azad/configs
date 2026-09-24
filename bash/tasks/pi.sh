#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

mkdir -p "$HOME_DIR/.pi/agent"
chmod 0755 "$HOME_DIR/.pi/agent"

sudo apt-get install -y nodejs npm

[[ -x /usr/bin/pi ]] || sudo npm install -g @earendil-works/pi-coding-agent

cfg="$HOME_DIR/.pi/agent/settings.json"

cat > "$cfg" <<'EOF'
{
  "defaultProvider": "openrouter",
  "defaultModel": "z-ai/glm-5.2"
}
EOF

pi install npm:pi-subagents
pi install npm:@zhushanwen/pi-ask-user
pi install npm:pi-agent-browser-native
pi install npm:pi-mcp-adapter
pi install npm:pi-notify
pi install npm:pi-vim
