#!/bin/bash

set -e

start_dir=$(pwd)

mkdir -p ~/code
cd ~/code

# btop
wget https://github.com/aristocratos/btop/releases/download/v1.4.5/btop-aarch64-linux-musl.tbz
tar -xjf btop-aarch64-linux-musl.tbz
cd btop
sudo make GPU_SUPPORT=true
python3 -m pip install nvidia-ml-py
cd ..
rm -rf btop-aarch64-linux-musl.tbz

cd "$start_dir"
