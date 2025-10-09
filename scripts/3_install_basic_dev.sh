#!/bin/bash

set -e

start_dir=$(pwd)

# deps
sudo apt install -y git build-essential ninja-build gettext cmake unzip curl xclip cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

# tmux
sudo apt install -y tmux

# ripgrep
sudo apt install -y ripgrep

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# neovim
mkdir -p ~/code
cd ~/code
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ..

# node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts

# alacritty
git clone https://github.com/alacritty/alacritty.git
cd alacritty
cargo build --release
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
sudo cp target/release/alacritty /usr/local/bin
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
mkdir -p ~/.bash_completion
cp extra/completions/alacritty.bash ~/.bash_completion/alacritty
echo "source ~/.bash_completion/alacritty" >> ~/.bashrc
cd ..

cd "$start_dir"
