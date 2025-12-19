#!/bin/bash

set -e

./scripts/install_compilers_android.sh
./scripts/install_software_common.sh
./scripts/install_software_android.sh
./scripts/setup_symlinks_common.sh
./scripts/setup_bashrc_common.sh
./scripts/setup_git.sh
