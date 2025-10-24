#!/bin/bash

set -e

git config --global user.name "$USER_FULL_NAME"
git config --global user.email "$USER_EMAIL_ADDRESS"

read -p "Do you want to use your own existing SSH key pair? [y/n]: "  ans
if [[ "$ans" == "n" || "$ans" == "N" ]]; then
  ssh-keygen -t ed25519 -C "$USER_EMAIL_ADDRESS" -f ~/.ssh/id_ed25519

  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519

  echo "Here is your SSH public key (add this to your GitHub account):"
  cat ~/.ssh/id_ed25519.pub
fi
