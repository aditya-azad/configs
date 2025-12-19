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

# python libs
pip3 install python-lsp-server python-lsp-black python-lsp-isort pylsp-mypy mypy flake8

# torch
pkg install python-torch python-torchvision python-torchaudio

cd "$start_dir"
