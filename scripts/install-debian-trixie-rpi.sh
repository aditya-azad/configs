#!/bin/bash

set -e

sudo mount -o remount,size=2G /tmp

./scripts/install_compilers_rpi.sh
./scripts/install_software_common.sh
./scripts/install_software_rpi.sh
./scripts/setup_symlinks_common.sh
./scripts/setup_bashrc_common.sh
./scripts/setup_bashrc_rpi.sh
./scripts/setup_git.sh
