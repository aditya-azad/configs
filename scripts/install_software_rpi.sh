#!/bin/bash

set -e

BASHRC_FILE="$HOME/.bashrc"

start_dir=$(pwd)

mkdir -p ~/code
cd ~/code

source ~/.cargo/env

# net tools
sudo apt install -y net-tools

# chrony
sudo apt install -y chrony

# du dust
cargo install du-dust

# ripgrep
cargo install ripgrep

# eza
cargo install eza

# python libs
pip3 install python-lsp-server python-lsp-black python-lsp-isort pylsp-mypy mypy flake8

# neovim
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ..
rm -rf neovim

# zellij
wget https://github.com/zellij-org/zellij/releases/download/v0.43.1/zellij-aarch64-unknown-linux-musl.tar.gz
tar -xzf zellij-aarch64-unknown-linux-musl.tar.gz
sudo mv zellij /usr/local/bin
rm zellij-aarch64-unknown-linux-musl.tar.gz

# btop
wget https://github.com/aristocratos/btop/releases/download/v1.4.5/btop-aarch64-linux-musl.tbz
tar -xjf btop-aarch64-linux-musl.tbz
cd btop
sudo make
cd ..
rm -rf btop-aarch64-linux-musl.tbz

# syncthing
pushd /tmp
wget https://github.com/syncthing/syncthing/releases/download/v2.0.11/syncthing-linux-arm64-v2.0.11.tar.gz
tar xzf syncthing-linux-arm64-v2.0.11.tar.gz
cp -r syncthing-linux-arm64-v2.0.11/ ~/syncthing
mkdir -p ~/.config/systemd/user/
cp ~/syncthing/etc/linux-systemd/user/syncthing.service ~/.config/systemd/user/
echo "export PATH=$PATH:$HOME/syncthing/"
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
popd

cd "$start_dir"
