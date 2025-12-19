#!/bin/bash

set -e

start_dir=$(pwd)

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# mise
curl https://mise.run | sh
eval "$(~/.local/bin/mise activate bash)"

# go
mise use -g go

# node
mise use --global node@lts

cd "$start_dir"
