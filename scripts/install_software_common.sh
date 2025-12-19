#!/bin/bash

set -e

start_dir=$(pwd)

mkdir -p ~/code
cd ~/code

source ~/.cargo/env

# ripgrep
cargo install ripgrep

# du dust
cargo install du-dust

# eza
cargo install eza

# neovim
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ..
rm -rf neovim

cd "$start_dir"
