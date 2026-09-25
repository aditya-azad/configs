#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

[[ -x /usr/bin/syncthing ]] || {
  sudo install -d -m 0755 /etc/apt/keyrings
  curl -fsSL https://syncthing.net/release-key.gpg \
    | sudo tee /etc/apt/keyrings/syncthing-archive-keyring.gpg >/dev/null
  echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" \
    | sudo tee /etc/apt/sources.list.d/syncthing.list >/dev/null
  sudo tee /etc/apt/preferences.d/syncthing >/dev/null <<'EOF'
Package: *
Pin: origin apt.syncthing.net
Pin-Priority: 990
EOF
  sudo apt-get update
  sudo apt-get install -y syncthing
}

rm -rf "$HOME_DIR/syncthing"
sed -i '/# BEGIN configs syncthing-path/,/# END configs syncthing-path/d' "$BASHRC_FILE"

systemctl --user disable --now syncthing.service 2>/dev/null || true
rm -f "$HOME_DIR/.config/systemd/user/syncthing.service"
systemctl --user daemon-reload

systemctl --user enable --now syncthing.service
