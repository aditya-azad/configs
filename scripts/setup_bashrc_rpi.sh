#!/bin/bash

set -e

BASHRC_FILE="$HOME/.bashrc"

# prompt
echo "PS1='\[\e[38;5;33m\]\u@\h:\w\[\e[0m\]\$ '" >> "$BASHRC_FILE"

# utils
echo "alias cat='bat'" >> "$BASHRC_FILE"
echo "alias top='btop'" >> "$BASHRC_FILE"
echo "alias htop='btop'" >> "$BASHRC_FILE"
