#!/usr/bin/env bash

setup_pi() {
  command -v pi >/dev/null 2>&1 || curl -fsSL https://pi.dev/install.sh | sh

  local cfg="$HOME_DIR/.pi/agent/settings.json"

  if [[ ! -f "$cfg" ]]; then
    mkdir -p "$(dirname "$cfg")"
    cat > "$cfg" <<EOF
{
  "theme": "omarchy-system",
  "packages": [
    {
      "source": "npm:pi-subagents",
      "extensions": ["./bundle/index.js"],
      "skills": [],
      "prompts": []
    },
    "npm:@zhushanwen/pi-ask-user",
    "npm:pi-agent-browser-native",
    "npm:pi-mcp-adapter",
    "npm:pi-notify",
    "npm:pi-vim"
    "npm:pi-token-speed"
  ],
  "defaultProvider": "openrouter",
  "skills": [
    "$HOME_DIR/code/flashcard-agent/skills",
    "$HOME_DIR/code/papers-agent/skills"
  ],
  "defaultModel": "z-ai/glm-5.3-flash",
  "hideThinkingBlock": true,
  "extensions": ["-builtin:mcp"]
}
EOF
  fi
}
