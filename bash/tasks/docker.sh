#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get update
sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl

sudo install -d -m 0755 /etc/apt/keyrings
tmp=$(mktemp)
curl -fsSL -o "$tmp" https://download.docker.com/linux/ubuntu/gpg
sudo install -m 0644 "$tmp" /etc/apt/keyrings/docker.asc
rm -f "$tmp"

docker_arch="$(dpkg --print-architecture)"
echo "deb [arch=$docker_arch signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update

sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y \
  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

if [[ "$ARCH" == "x86_64" ]]; then
  [[ -f /tmp/docker-desktop-amd64.deb ]] || \
    curl -fsSL -o /tmp/docker-desktop-amd64.deb "https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb"
  sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y /tmp/docker-desktop-amd64.deb
fi
