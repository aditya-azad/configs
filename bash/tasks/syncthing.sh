#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

syncthing_version="2.0.11"
if [[ "$ARCH" == "x86_64" ]]; then
  syncthing_arch_dir="syncthing-linux-amd64-v$syncthing_version"
  syncthing_archive="syncthing-linux-amd64-v$syncthing_version.tar.gz"
else
  syncthing_arch_dir="syncthing-linux-arm64-v$syncthing_version"
  syncthing_archive="syncthing-linux-arm64-v$syncthing_version.tar.gz"
fi

[[ -f "/tmp/$syncthing_archive" ]] || \
  curl -fsSL -o "/tmp/$syncthing_archive" \
    "https://github.com/syncthing/syncthing/releases/download/v$syncthing_version/$syncthing_archive"

if [[ ! -x "$HOME_DIR/syncthing/syncthing" ]]; then
  bash -c "set -e; cd '$HOME_DIR'; tar xzf '/tmp/$syncthing_archive'; rm -rf syncthing; mv '$syncthing_arch_dir' syncthing"
fi

mkdir -p "$HOME_DIR/.config/systemd/user"
chmod 0755 "$HOME_DIR/.config/systemd/user"
cp -f "$HOME_DIR/syncthing/etc/linux-systemd/user/syncthing.service" \
      "$HOME_DIR/.config/systemd/user/syncthing.service"
chmod 0644 "$HOME_DIR/.config/systemd/user/syncthing.service"

sed -i '/# BEGIN configs syncthing-path/,/# END configs syncthing-path/d' "$BASHRC_FILE"
cat >> "$BASHRC_FILE" <<'EOF'
# BEGIN configs syncthing-path
export PATH=${PATH}:${HOME}/syncthing/
# END configs syncthing-path
EOF

systemctl --user daemon-reload
systemctl --user enable --now syncthing.service
