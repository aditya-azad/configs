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
  "theme": "omarchy-system",
  "packages": [
    "npm:pi-subagents",
    "npm:@zhushanwen/pi-ask-user",
    "npm:pi-agent-browser-native",
    "npm:pi-mcp-adapter",
    "npm:pi-notify",
    "npm:pi-vim"
  ],
  "defaultProvider": "openrouter",
  "defaultModel": "z-ai/glm-5.3-flash"
}
EOF

# hugo
sudo pacman -S hugo

# anki
sudo pacman -S anki

# global protect
yay -S globalprotect-openconnect
ln -sfn "$HOME/.config/scripts/wpi-vpn" "$HOME/.local/bin/wpi-vpn"

# nvidia container toolkit (docker gpu)
sudo pacman -S nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# macos container (start-mac)
ln -sfn "$HOME/.config/scripts/start-mac" "$HOME/.local/bin/start-mac"
