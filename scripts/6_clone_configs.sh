#!/bin/bash

set -e

mkdir -p ~/code
pushd code
git@github.com:aditya-azad/configs.git
popd code
