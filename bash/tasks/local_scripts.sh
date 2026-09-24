#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y jq zip gh distrobox openconnect

if [[ "$ARCH" == "x86_64" ]]; then
  sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y \
    qemu-system qemu-utils swtpm virt-viewer ovmf
fi

for d in "$HOME_DIR/.local/bin" "$HOME_DIR/.local/lib" "$HOME_DIR/.local/share" \
         "$HOME_DIR/.vms" "$HOME_DIR/.vms/windows"; do
  mkdir -p "$d"
  chmod 0755 "$d"
done

cp -a "$PACKAGES_DIR/theme-switch/." "$HOME_DIR/.local/share/theme-switch/"
chmod 0755 "$HOME_DIR/.local/share/theme-switch/st"
ln -sfn "$HOME_DIR/.local/share/theme-switch/st" "$HOME_DIR/.local/bin/st"

cp -a "$PACKAGES_DIR/distrobox/." "$HOME_DIR/.local/share/distrobox/"
chmod 0755 "$HOME_DIR/.local/share/distrobox/db"
ln -sfn "$HOME_DIR/.local/share/distrobox/db" "$HOME_DIR/.local/bin/db"

install -m 0755 "$PACKAGES_DIR/wpi-vpn/wpi-vpn" "$HOME_DIR/.local/bin/wpi-vpn"
install -m 0755 "$PACKAGES_DIR/ghclone/ghclone"  "$HOME_DIR/.local/bin/ghclone"

install -m 0755 "$PACKAGES_DIR/qvm/qvm"            "$HOME_DIR/.local/bin/qvm"
install -m 0644 "$PACKAGES_DIR/qvm/vms/windows.sh" "$HOME_DIR/.vms/windows/windows.sh"

install -m 0644 "$PACKAGES_DIR/venvup/venvup" "$HOME_DIR/.local/lib/venvup"
install -m 0644 "$PACKAGES_DIR/rdid/rdid"     "$HOME_DIR/.local/lib/rdid"

blockinfile "$BASHRC_FILE" "qvm-ovmf" <<'EOF'
export QVM_OVMF_CODE="/usr/share/OVMF/OVMF_CODE.fd"
export QVM_OVMF_VARS="/usr/share/OVMF/OVMF_VARS.fd"
EOF
