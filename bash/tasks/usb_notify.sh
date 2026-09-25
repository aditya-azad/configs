#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo apt-get install -y libnotify-bin

sudo install -Dm755 /dev/stdin /usr/local/bin/usb-notify <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

DEVNAME="${DEVNAME:-}"
[[ -n "$DEVNAME" ]] || exit 0

vendor="${ID_VENDOR:-}"
model="${ID_MODEL:-}"
label="${ID_FS_LABEL:-}"

while IFS='=' read -r k v; do
  case "$k" in
    ID_VENDOR) [[ -z "$vendor" ]] && vendor="${v:-}";;
    ID_MODEL)  [[ -z "$model" ]]  && model="${v:-}";;
    ID_FS_LABEL) [[ -z "$label" ]] && label="${v:-}";;
  esac
done < <(udevadm info --query=property --name="$DEVNAME" 2>/dev/null || true)

title="USB drive added"
body="${vendor:+$vendor }${model:-}"
[[ -n "$body" ]] || body="$DEVNAME"
[[ -n "$label" ]] && body="$body — $label"

for bus in /run/user/*/bus; do
  [[ -S "$bus" ]] || continue
  uid="$(stat -c %u "$bus")"
  user="$(getent passwd "$uid" | cut -d: -f1)"
  [[ -n "$user" ]] || continue
  active=""
  while read -r s; do
    [[ -n "$s" ]] || continue
    stype="$(loginctl show-session "$s" --value -p Type 2>/dev/null | head -n1 || true)"
    [[ "$stype" == "wayland" || "$stype" == "x11" ]] || continue
    [[ "$(loginctl show-session "$s" --value -p Active 2>/dev/null | head -n1 || true)" == "yes" ]] || continue
    active=1; break
  done < <(loginctl show-user "$user" --value -p Sessions 2>/dev/null | tr ' ' '\n' || true)
  [[ -n "$active" ]] || continue
  runuser -u "$user" -- env \
    DBUS_SESSION_BUS_ADDRESS="unix:path=$bus" \
    XDG_RUNTIME_DIR="/run/user/$uid" \
    notify-send --app-name=USB --icon=media-removable --urgency=normal "$title" "$body" 2>/dev/null || true
  break
done

exit 0
EOF

sudo install -Dm644 /dev/stdin /etc/udev/rules.d/90-usb-notify.rules <<'EOF'
ACTION=="add", SUBSYSTEM=="block", ENV{ID_BUS}=="usb", ENV{DEVTYPE}=="disk", RUN+="/usr/local/bin/usb-notify"
EOF

sudo udevadm control --reload-rules
