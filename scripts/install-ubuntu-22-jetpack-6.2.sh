#!/bin/bash

set -e

./scripts/install_compilers_jetson.sh
./scripts/install_software_jetson.sh
./scripts/setup_symlinks_common.sh
./scripts/setup_bashrc_common.sh
./scripts/setup_bashrc_jetson.sh
./scripts/setup_git.sh
