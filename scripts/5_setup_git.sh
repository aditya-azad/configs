#!/bin/bash

set -e

git_username="aditya-azad"
git_email="adityaazad121@gmail.com"

git config --global user.name "$git_username"
git config --global user.email "$git_email"

read -p "Enter your GitHub email for SSH key: " ssh_email
ssh-keygen -t ed25519 -C "$ssh_email" -f ~/.ssh/id_ed25519 -N ""

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

echo "Here is your SSH public key (add this to your GitHub account):"
cat ~/.ssh/id_ed25519.pub
