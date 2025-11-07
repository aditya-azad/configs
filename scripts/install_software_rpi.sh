#!/bin/bash

set -e

BASHRC_FILE="$HOME/.bashrc"

start_dir=$(pwd)

mkdir -p ~/code
cd ~/code

source ~/.cargo/env

# bat
cargo install bat

# btop
wget https://github.com/aristocratos/btop/releases/download/v1.4.5/btop-aarch64-linux-musl.tbz
tar -xjf btop-aarch64-linux-musl.tbz
cd btop
sudo make GPU_SUPPORT=true
python3 -m pip install nvidia-ml-py
cd ..
rm -rf btop-aarch64-linux-musl.tbz

# syncthing
pushd /tmp
wget https://github.com/syncthing/syncthing/releases/download/v2.0.11/syncthing-linux-arm64-v2.0.11.tar.gz
tar xzf syncthing-linux-arm64-v2.0.10.tar.gz
cp -r syncthing-linux-arm64-v2.0.10/ ~/syncthing
mkdir -p ~/.config/systemd/user/
cp ~/syncthing/etc/linux-systemd/user/syncthing.service ~/.config/systemd/user/
echo "export PATH=$PATH:$HOME/syncthing/"
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
popd

cd "$start_dir"
