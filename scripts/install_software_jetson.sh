#!/bin/bash

set -e

start_dir=$(pwd)

mkdir -p ~/code
cd ~/code

# net tools
sudo apt install -y net-tools

# chrony
sudo apt install -y chrony

# zellij
cargo install zellij

# du dust
cargo install du-dust

# ripgrep
cargo install ripgrep

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

# btop
wget https://github.com/aristocratos/btop/releases/download/v1.4.5/btop-aarch64-linux-musl.tbz
tar -xjf btop-aarch64-linux-musl.tbz
cd btop
sudo make GPU_SUPPORT=true
python3 -m pip install nvidia-ml-py
cd ..
rm -rf btop-aarch64-linux-musl.tbz

cd "$start_dir"
