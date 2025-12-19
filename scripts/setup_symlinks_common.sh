#!/bin/bash

set -e

mkdir -p "$HOME/.config/nvim"
ln -s "$HOME/code/configs/nvim" "$HOME/.config/nvim"
rm -rf $HOME/.config/zellij
mkdir -p "$HOME/.config/zellij"
ln -s "$HOME/code/configs/zellij" "$HOME/.config/zellij"
mkdir -p "$HOME/.config/btop"
ln -s "$HOME/code/configs/btop" "$HOME/.config/btop"
