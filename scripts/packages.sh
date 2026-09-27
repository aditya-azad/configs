#!/bin/bash

# firacode
omarchy pkg add ttf-firacode-nerd

# steam
sudo omarchy-pkg-add steam

# keepass
sudo pacman -Sy keepassxc

# freefilesync
yay -S freefilesync-bin

# zellij
sudo pacman -Sy zellij

# pi
curl -fsSL https://pi.dev/install.sh | sh

# pi configs
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
