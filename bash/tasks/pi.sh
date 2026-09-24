#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

mkdir -p "$HOME_DIR/.pi/agent"
chmod 0755 "$HOME_DIR/.pi/agent"

sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs npm

[[ -x /usr/bin/pi ]] || sudo npm install -g @earendil-works/pi-coding-agent

cfg="$HOME_DIR/.pi/agent/settings.json"
touch "$cfg"
tmp="$(mktemp)"
jq --arg p "openrouter" \
   --arg m "z-ai/glm-5.2" \
   '. + {
     "defaultProvider": $p,
     "defaultModel": $m,
     "packages": [
       "npm:pi-subagents",
       "npm:@zhushanwen/pi-ask-user",
       "npm:pi-agent-browser-native",
       "npm:pi-mcp-adapter",
       "npm:pi-notify",
       "npm:pi-vim"
     ]
   }' "$cfg" > "$tmp" && mv "$tmp" "$cfg"
