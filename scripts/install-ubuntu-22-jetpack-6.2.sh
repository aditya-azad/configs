#!/bin/bash

set -e

./scripts/setup_user.sh
./scripts/upgrade.sh
./scripts/install_compilers.sh
./scripts/install_software_common.sh
./scripts/install_software_jetson.sh
./scripts/setup_symlinks_common.sh
./scripts/setup_bashrc_common.sh
./scripts/setup_bashrc_jetson.sh
./scripts/setup_git.sh
