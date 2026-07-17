#!/bin/bash

set -e

rm -rf "$HOME/.config/kitty"
ln -s "$HOME/code/configs/kitty" "$HOME/.config/kitty"
