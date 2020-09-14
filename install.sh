#!/bin/bash

CONFIGDIR=./configs
HOMEDIR=~

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
  ln "$CONFIGDIR/.tmux.conf" "$HOMEDIR/"
  # zsh
  ln "$CONFIGDIR/.zshrc" "$HOMEDIR/.zshrc"
  # profile
  ln "$CONFIGDIR/.profile" "$HOMEDIR/.profile"
  # alacritty
  mkdir "$HOMEDIR/.configs/alacritty"
  for entry in "$CONFIGDIR/.configs/alacritty"/*; do
    ln "$entry" "$HOMEDIR/.configs/alacritty/"
  done
  # newsboat
  mkdir "$HOMEDIR/.newsboat"
  for entry in "$CONFIGDIR/.newsboat"/*; do
    ln "$entry" "$HOMEDIR/.newsboat/"
  done
  # nvim
  mkdir "$HOMEDIR/.configs/nvim"
  for entry in "$CONFIGDIR/.configs/nvim"/*; do
    ln "$entry" "$HOMEDIR/.configs/nvim/"
  done
  print_green "[*] Configuring done"
}

clean_configs() {
  print_green "[*] Cleaning configs"
  # tmux
  rm "$HOMEDIR/.tmux.conf"
  # zsh
  rm "$HOMEDIR/.zshrc"
  # profile
  rm "$HOMEDIR/.profile"
  # vim
  sudo rm "$HOMEDIR/.vim" -r
  rm "$HOMEDIR/.vimrc"
  sudo rm "$HOMEDIR/.configs/nvim" -r
  # newsboat
  sudo rm -r "$HOMEDIR/.newsboat"
  # ranger
  sudo rm "$HOMEDIR/.configs/ranger" -r
  # alacritty
  sudo rm "$HOMEDIR/.configs/alacritty" -r
  print_green "[*] Cleaning configs done"
}

install_software() {
  print_green "[*] Installing"
  # nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
  # oh my zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  # yay, neovim, git, tmux, newsboat, alacritty
  sudo pacman -S yay neovim newsboat git tmux alacritty
  # brave
  yay -S brave-bin
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
