#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y blueman

mkdir -p "$HOME_DIR/.config/systemd/user"
chmod 0755 "$HOME_DIR/.config/systemd/user"

unit="$HOME_DIR/.config/systemd/user/blueman-applet.service"
unit_new="$(mktemp)"
cat > "$unit_new" <<'EOF'
[Unit]
Description=blueman bluetooth applet (BlueZ pairing agent)
PartOf=graphical-session.target
After=graphical-session.target

[Service]
ExecStart=/usr/bin/blueman-applet
Restart=on-failure
RestartSec=5

[Install]
WantedBy=graphical-session.target
EOF

unit_changed=0
if [[ ! -f "$unit" ]]; then
  unit_changed=1
elif ! diff -q "$unit_new" "$unit" >/dev/null 2>&1; then
  unit_changed=1
fi
if [[ "$unit_changed" == 1 ]]; then
  install -m 0644 "$unit_new" "$unit"
fi
rm -f "$unit_new"

systemctl --user daemon-reload
systemctl --user enable --now blueman-applet.service 2>/dev/null || true
