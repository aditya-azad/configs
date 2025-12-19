#!/bin/bash

set -e

start_dir=$(pwd)

# deps
sudo apt install -y git build-essential ninja-build gettext cmake unzip curl xclip cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 python3-venv python3-pip

# mise
curl https://mise.run | sh
eval "$(~/.local/bin/mise activate bash)"

# go
mise use -g go

# node
mise use --global node@lts

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

cd "$start_dir"
