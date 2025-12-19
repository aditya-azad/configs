#!/bin/bash

set -e

ln -s "$HOME/code/configs/nvim" "$HOME/.config/nvim"
rm -rf $HOME/.config/zellij
ln -s "$HOME/code/configs/zellij" "$HOME/.config/zellij"
ln -s "$HOME/code/configs/btop" "$HOME/.config/btop"
