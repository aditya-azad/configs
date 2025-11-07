#!/bin/bash

set -e

./scripts/upgrade.sh
./scripts/install_compilers.sh
./scripts/install_software_common.sh
./scripts/install_software_desktop.sh
./scripts/install_popshell.sh
./scripts/install_fonts.sh
./scripts/setup_gnome.sh
./scripts/setup_symlinks_common.sh
./scripts/setup_symlinks_desktop.sh
./scripts/setup_bashrc_common.sh
./scripts/setup_bashrc_desktop.sh
./scripts/setup_hosts.sh
./scripts/uninstall.sh
./scripts/setup_git.sh
