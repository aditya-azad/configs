#!/bin/bash

set -e

UNZIP_DIR="/tmp/firacode"

mkdir -p $UNZIP_DIR
unzip ./font/FiraCode.zip -d "$UNZIP_DIR"
mkdir -p ~/.local/share/fonts
cp "$UNZIP_DIR"/* ~/.local/share/fonts/
fc-cache -f -v
rm -rf "$UNZIP_DIR"
