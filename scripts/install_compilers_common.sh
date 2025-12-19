#!/bin/bash

set -e

start_dir=$(pwd)

# mise
curl https://mise.run | sh
eval "$(~/.local/bin/mise activate bash)"

# go
mise use -g go

# node
mise use --global node@lts

cd "$start_dir"
