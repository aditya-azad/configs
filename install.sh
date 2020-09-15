#!/bin/bash

SCRIPTS_DIR=$(dirname $(readlink -f "$0"))/scripts

CONFIG_DIR=$(dirname $(readlink -f "$0"))/configs
CONFIG_DOT_CONFIG=$CONFIG_DIR/.config

HOME_DIR=/home/$USER
USER_DOT_CONFIG=$HOME_DIR/.config

print_help () {
  echo "Enter some arguments"
  echo "i : install the required software (pacman)"
  echo "c : install the configs"
  echo "r : remove current configs"
}

print_green () {
  local green="\033[0;32m"
  local nc="\033[0m"
  echo -e "$green $1 $nc"
  echo -n -E ""
}

config_env() {
  print_green "[*] Configuring"
  # tmux
  ln "$CONFIG_DIR/.tmux.conf" "$HOME_DIR/"
  # zsh
  ln "$CONFIG_DIR/.zshrc" "$HOME_DIR/.zshrc"
  # profile
  ln "$CONFIG_DIR/.profile" "$HOME_DIR/.profile"
  # alacritty
  mkdir "$USER_DOT_CONFIG/alacritty"
  for entry in "$CONFIG_DOT_CONFIG/alacritty"/*; do
    ln "$entry" "$USER_DOT_CONFIG/alacritty"
  done
  # newsboat
  mkdir "$HOME_DIR/.newsboat"
  for entry in "$CONFIG_DIR/.newsboat"/*; do
    ln "$entry" "$HOME_DIR/.newsboat"
  done
  # nvim
  mkdir "$USER_DOT_CONFIG/nvim/"
  for entry in "$CONFIG_DOT_CONFIG/nvim"/*; do
    ln "$entry" "$USER_DOT_CONFIG/nvim"
  done
  print_green "[*] Configuring done"
}

clean_configs() {
  print_green "[*] Cleaning configs"
  # tmux
  rm "$HOME_DIR/.tmux.conf"
  # zsh
  rm "$HOME_DIR/.zshrc"
  # profile
  rm "$HOME_DIR/.profile"
  # vim
  sudo rm "$HOME_DIR/.vim" -r
  rm "$HOME_DIR/.vimrc"
  sudo rm "$USER_DOT_CONFIG/nvim" -r
  # newsboat
  sudo rm -r "$HOME_DIR/.newsboat"
  # alacritty
  sudo rm "$USER_DOT_CONFIG/alacritty" -r
  print_green "[*] Cleaning configs done"
}

install_software() {
  print_green "[*] Installing"
  # nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
  # oh my zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  # yay, neovim, git, tmux, newsboat, alacritty, keepass
  sudo pacman -S yay neovim newsboat git tmux alacritty keepass
  # brave
   yay -S brave-bin
  # hack font
  chmod +x $SCRIPTS_DIR/hack-font.sh
  $SCRIPTS_DIR/hack-font.sh latest
  print_green "[*] Installing done"
}

if [ -z "$@" ]; then
  print_help
else
  for arg in $@; do # loop over all arguments
    if [ $arg == "i" ]; then
      install_software
    elif [ $arg == "c" ]; then
      config_env
    elif [ $arg == "r" ]; then
      clean_configs
    else
      print_help
    fi
  done
fi
