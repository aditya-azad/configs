#!/bin/bash

set -e

BASHRC_FILE="$HOME/.bashrc"

start_dir=$(pwd)

mkdir -p ~/code
cd ~/code

source ~/.cargo/env

# zellij
cargo install zellij

# bat
cargo install bat

# bacon
cargo install --locked bacon

# cargo info
sudo apt install -y libssl-dev
cargo install cargo-info

# heic picture support
sudo apt install -y heif-gdk-pixbuf heif-thumbnailer

# krita
sudo apt install -y krita

# keepass
sudo apt install -y keepass2

# xournal++
sudo apt install -y xournalpp

# calibre
sudo apt install -y calibre

# brave
curl -fsS https://dl.brave.com/install.sh | sh

# nvidia driver
sudo apt install nvidia-driver-570

# cuda 12.6
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.6.0/local_installers/cuda-repo-ubuntu2204-12-6-local_12.6.0-560.28.03-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-12-6-local_12.6.0-560.28.03-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-12-6-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update -y
sudo apt-get -y install cuda-toolkit-12-6
echo "export PATH=${PATH}:/usr/local/cuda-12.6/bin" >> "$BASHRC_FILE"
echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda-12.6/lib64" >> "$BASHRC_FILE"

# nvidia container toolkit
sudo apt install -y nvidia-cuda-toolkit

# btop
wget https://github.com/aristocratos/btop/releases/download/v1.4.5/btop-x86_64-linux-musl.tbz
tar -xjf btop-x86_64-linux-musl.tbz
cd btop
sudo make GPU_SUPPORT=true
python3 -m pip install nvidia-ml-py
cd ..
rm -rf btop-x86_64-linux-musl.tbz

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
rm -rf alacritty

# ros2 humble
sudo apt install software-properties-common
sudo add-apt-repository universe
sudo apt update -y && sudo apt install curl -y
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb
sudo apt update -y
sudo apt install -y ros-humble-desktop
sudo apt install -y ros-dev-tools

# docker
sudo apt-get -y update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
pushd /tmp
wget -O docker-desktop-amd64.deb "https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64"
sudo apt-get install -y ./docker-desktop-amd64.deb
popd

# syncthing
pushd /tmp
wget https://github.com/syncthing/syncthing/releases/download/v2.0.10/syncthing-linux-amd64-v2.0.11.tar.gz
tar xzf syncthing-linux-amd64-v2.0.11.tar.gz
cp -r syncthing-linux-amd64-v2.0.11/ ~/syncthing
mkdir -p ~/.config/systemd/user/
cp ~/syncthing/etc/linux-systemd/user/syncthing.service ~/.config/systemd/user/
echo "export PATH=$PATH:$HOME/syncthing/"
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
popd

# virtualbox
pushd /tmp
wget https://download.virtualbox.org/virtualbox/7.2.2/virtualbox-7.2_7.2.2-170484~Ubuntu~jammy_amd64.deb
sudo apt install -y ./virtualbox-7.2_7.2.2-170484~Ubuntu~jammy_amd64.deb
popd

# steam
pushd /tmp
wget https://cdn.fastly.steamstatic.com/client/installer/steam.deb
sudo apt install -y ./steam.deb
popd

# freefilesync
pushd /tmp
wget https://freefilesync.org/download/FreeFileSync_14.5_Linux_x86_64.tar.gz
tar xzf ./FreeFileSync_14.5_Linux_x86_64.tar.gz
chmod +x ./FreeFileSync_14.5_Install.run
./FreeFileSync_14.5_Install.run
popd

cd "$start_dir"
