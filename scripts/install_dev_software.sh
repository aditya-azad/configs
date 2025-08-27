#!/bin/bash

start_dir=$(pwd)

# deps
sudo apt install -y git build-essential ninja-build gettext cmake unzip curl

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

cd "$start_dir"
