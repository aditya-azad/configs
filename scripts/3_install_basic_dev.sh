#!/bin/bash

set -e

start_dir=$(pwd)

# deps
sudo apt install -y git build-essential ninja-build gettext cmake unzip curl xclip

# tmux
sudo apt install -y tmux

# ripgrep
sudo apt install -y ripgrep

# neovim
mkdir -p ~/code
cd ~/code
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

# node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm use --lts

cd "$start_dir"
