#!/bin/bash

set -e

rm -rf "$HOME/.config/kitty"
ln -s "$HOME/code/configs/kitty" "$HOME/.config/kitty"
ln -s "$HOME/code/configs/refree" "$HOME/.refree"
mkdir -p "$HOME/.local/state/syncthing"
for f in cert.pem config.xml https-cert.pem https-key.pem key.pem; do
  rm -f "$HOME/.local/state/syncthing/$f"
  ln -s "$HOME/database/docs/passwords-keys/syncthing-legion-7i/$f" "$HOME/.local/state/syncthing/$f"
done
