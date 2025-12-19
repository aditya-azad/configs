#!/bin/bash

set -e

start_dir=$(pwd)

# deps
sudo apt install -y git build-essential ninja-build gettext cmake unzip curl xclip cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# mise
curl https://mise.run | sh
eval "$(~/.local/bin/mise activate bash)"

# python
mise use -g python@3.12
mise use -g uv@latest

# go
mise use -g go

# node
mise use --global node@lts

cd "$start_dir"
