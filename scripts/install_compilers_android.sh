#!/bin/bash

set -e

start_dir=$(pwd)

# deps
pkg install git build-essential gettext unzip curl cmake clang pkg-config python rust golang nodejs-lts

cd "$start_dir"
