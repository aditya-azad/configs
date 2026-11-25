#!/usr/bin/env bash

set -euo pipefail

USERNAME="azada"
ROS_DOMAIN_ID=0
PX4_PATH="$HOME/code/PX4-Autopilot"

source "$HOME/.config/scripts/common/env.sh"
source "$HOME/.config/scripts/common/links.sh"
source "$HOME/.config/scripts/common/bashrc.sh"
source "$HOME/.config/scripts/common/pi.sh"

require_user "$USERNAME"

pkg_has ttf-firacode-nerd || omarchy pkg add ttf-firacode-nerd

pkg_has steam || sudo omarchy-pkg-add steam

pkg_has keepassxc || sudo pacman -S --noconfirm keepassxc

pkg_has calibre || sudo pacman -S --noconfirm calibre

pkg_has freefilesync-bin || yay -S --noconfirm freefilesync-bin

omarchy plugin add https://github.com/ninepointlabs/omasync.git --enable
pkg_has freefilesync-bin || omarchy pkg add syncthing

omarchy plugin add https://github.com/key-tone/omarchy-nightlight.git --enable

pkg_has zellij || sudo pacman -S --noconfirm zellij

pkg_has hugo || sudo pacman -S --noconfirm hugo

pkg_has anki || sudo pacman -S --noconfirm anki

pkg_has pureref || yay -S pureref

pkg_has texlive-latexextra || sudo pacman -S --noconfirm texlive-latexextra texlive-binextra

LH_DATA_TARGET="$HOME_DIR/database/workspace/notes/learnharness/data"
mkdir -p "$LH_DATA_TARGET"
ln -sfn "$LH_DATA_TARGET" "$HOME_DIR/.config/LearnHarness/data"

pkg_has globalprotect-openconnect || yay -S --noconfirm globalprotect-openconnect

pkg_has nvidia-container-toolkit || sudo pacman -S --noconfirm nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

setup_pi

setup_bin_links

write_bashrc_block

update_host() {
  local ip="$1" name="$2"
  if grep -qE "^[[:space:]]*${ip}[[:space:]]+${name}[[:space:]]*$" /etc/hosts; then
    sudo sed -i -E "s|^[[:space:]]*${ip}[[:space:]]+${name}[[:space:]]*$|${ip} ${name}|" /etc/hosts
  else
    echo "${ip} ${name}" | sudo tee -a /etc/hosts >/dev/null
  fi
}

update_host "192.168.55.1" "jetson"
update_host "130.215.183.33" "bizon"

echo "hosts updated:"
grep -E "jetson|bizon" /etc/hosts
