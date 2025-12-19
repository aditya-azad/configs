#!/bin/bash

set -e

start_dir=$(pwd)

mkdir -p ~/code
cd ~/code

# zellij
cargo install zellij

cd "$start_dir"
