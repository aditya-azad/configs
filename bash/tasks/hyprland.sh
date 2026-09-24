#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

mkdir -p "$HOME_DIR/.local/bin"
chmod 0755 "$HOME_DIR/.local/bin"
curl -fsSL -o "$HOME_DIR/.local/bin/hyprbuntu.sh" https://gitlab.com/kralos/hyprbuntu/-/raw/main/hyprbuntu.sh
chmod 0755 "$HOME_DIR/.local/bin/hyprbuntu.sh"

if [[ ! -x /usr/bin/Hyprland ]]; then
  env BUILD_DIR="$CODE_DIR/hyprbuntu" \
      DISABLE_CONFIRM=true \
      HYPRIDLE_SETUP=true \
      HYPRLOCK_SETUP=true \
      HYPRPAPER_SETUP=true \
      HYPRSHOT_SETUP=true \
      NVIDIA_SETUP=true \
      SWAYOSD_SETUP=false \
      THEME_PREF=none \
      THUNAR_SETUP=false \
      TUIGREET_SETUP=true \
      WAYBAR_SETUP=false \
      "$HOME_DIR/.local/bin/hyprbuntu.sh"
fi

gsettings set org.gnome.desktop.interface icon-theme "Yaru"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.interface clock-format "'12h'"
gsettings set org.gnome.desktop.peripherals.keyboard delay 150
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:none']"

xdg-settings set default-web-browser brave-browser.desktop
gsettings set org.gnome.desktop.default-applications.terminal exec "'kitty'"
gsettings set org.gnome.desktop.default-applications.terminal exec-arg "''"

sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator \
  "$HOME_DIR/.local/kitty.app/bin/kitty" 50 2>/dev/null || true

sudo apt-get install -y plymouth-theme-spinner
cur="$(plymouth-set-default-theme 2>/dev/null || true)"
if [[ "$cur" != "spinner" ]]; then
  sudo plymouth-set-default-theme -R spinner
fi

sudo mkdir -p /etc/systemd/logind.conf.d
sudo chmod 0755 /etc/systemd/logind.conf.d
lid_new="$(mktemp)"
cat > "$lid_new" <<'EOF'
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalMonitors=ignore
HandleLidSwitchDocked=ignore
EOF
lid_dst="/etc/systemd/logind.conf.d/lid.conf"
lid_changed=0
if [[ ! -f "$lid_dst" ]]; then
  lid_changed=1
elif ! diff -q "$lid_new" "$lid_dst" >/dev/null 2>&1; then
  lid_changed=1
fi
if [[ "$lid_changed" == 1 ]]; then
  sudo install -m 0644 "$lid_new" "$lid_dst"
fi
rm -f "$lid_new"

mkdir -p "$HOME_DIR/.config/hypr"
chmod 0755 "$HOME_DIR/.config/hypr"
ln -sfn "$CONFIGS_REPO/hypr/hyprland.lua" "$HOME_DIR/.config/hypr/hyprland.lua"
