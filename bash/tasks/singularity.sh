#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y \
  autoconf automake cryptsetup fuse2fs git fuse libfuse-dev \
  libseccomp-dev libtool pkg-config runc squashfs-tools squashfs-tools-ng \
  uidmap wget zlib1g-dev

mkdir -p "$CODE_DIR"
chmod 0755 "$CODE_DIR"

if [[ ! -d "$CODE_DIR/singularity-ce-4.3.0" ]]; then
  bash -c "set -e; cd '$CODE_DIR'; curl -fsSL https://github.com/sylabs/singularity/releases/download/v4.3.0/singularity-ce-4.3.0.tar.gz | tar xzf -"
fi

if [[ ! -f "$CODE_DIR/singularity-ce-4.3.0/builddir/Makefile" ]]; then
  bash -c "set -e; cd '$CODE_DIR/singularity-ce-4.3.0'; ./mconfig --without-libsubid"
fi

if [[ ! -f "$CODE_DIR/singularity-ce-4.3.0/builddir/singularity" ]]; then
  bash -c "set -e; cd '$CODE_DIR/singularity-ce-4.3.0'; make -C builddir"
fi

[[ -x /usr/local/bin/singularity ]] || \
  sudo make -C "$CODE_DIR/singularity-ce-4.3.0/builddir" install
