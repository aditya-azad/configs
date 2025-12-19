#!/bin/bash

set -e

start_dir=$(pwd)

mkdir -p ~/code
cd ~/code

# zellij
pkg install zellij

# eza
pkg install eza

# ripgrep
pkg install ripgrep

# neovim
pkg install neovim

cd "$start_dir"
