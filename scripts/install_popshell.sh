#!/bin/bash

set -e

# install deps
eval "$(~/.local/bin/mise activate bash)"
npm install -g typescript@latest

# install shell
mkdir -p ~/code
pushd ~/code
git clone https://github.com/pop-os/shell
pushd shell
git checkout master_jammy
make local-install
popd
rm -rf shell
popd
