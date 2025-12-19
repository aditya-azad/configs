#!/bin/bash

set -e

start_dir=$(pwd)

mkdir -p ~/code
cd ~/code

source ~/.cargo/env

eval "$(~/.local/bin/mise activate bash)"

# net tools
sudo apt install -y net-tools

# chrony
sudo apt install -y chrony

# zellij
cargo install zellij

# du dust
cargo install du-dust

# ripgrep
cargo install ripgrep

# eza
cargo install eza

# python libs
pip3 install python-lsp-server python-lsp-black python-lsp-isort pylsp-mypy mypy flake8 catkin_pkg numpy empy==3.3.4 lark pyyaml

# neovim
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ..
rm -rf neovim

# btop
wget https://github.com/aristocratos/btop/releases/download/v1.4.5/btop-aarch64-linux-musl.tbz
tar -xjf btop-aarch64-linux-musl.tbz
cd btop
sudo make GPU_SUPPORT=true
python3 -m pip install nvidia-ml-py
cd ..
rm -rf btop-aarch64-linux-musl.tbz

# singularity
pushd ~/code
sudo apt-get install -y \
   autoconf \
   automake \
   cryptsetup \
   fuse2fs \
   git \
   fuse \
   libfuse-dev \
   libseccomp-dev \
   libtool \
   pkg-config \
   runc \
   squashfs-tools \
   squashfs-tools-ng \
   uidmap \
   wget \
   zlib1g-dev
export VERSION=4.3.0 && \
    wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-ce-${VERSION}.tar.gz && \
    tar -xzf singularity-ce-${VERSION}.tar.gz && \
    cd singularity-ce-${VERSION}
./mconfig --without-libsubid && \
    make -C builddir && \
    sudo make -C builddir install
cd ..
rm -rf singularity*
popd

cd "$start_dir"
