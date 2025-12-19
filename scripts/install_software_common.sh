#!/bin/bash

set -e

start_dir=$(pwd)

mkdir -p ~/code
cd ~/code

source ~/.cargo/env

# neovim
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ..
rm -rf neovim

cd "$start_dir"
