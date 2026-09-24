#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

gset() { gsettings set "$1" "$2" "$3"; }

sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y \
  ubuntu-desktop gdm3 make gettext libglib2.0-bin git vlc
sudo systemctl enable --now gdm.service

if [[ -d "$CODE_DIR/forge/.git" ]]; then
  git -C "$CODE_DIR/forge" fetch --all 2>/dev/null || true
  git -C "$CODE_DIR/forge" checkout main 2>/dev/null || true
  git -C "$CODE_DIR/forge" reset --hard origin/main 2>/dev/null || true
else
  git clone --depth 1 --branch main https://github.com/forge-ext/forge.git "$CODE_DIR/forge"
fi

forge_ext="$HOME_DIR/.local/share/gnome-shell/extensions/forge@jmmaranan.com/metadata.json"
if [[ ! -f "$forge_ext" ]]; then
  bash -c "set -e; cd '$CODE_DIR/forge'; make build install"
fi

mkdir -p "$HOME_DIR/.local/share/glib-2.0/schemas"
chmod 0755 "$HOME_DIR/.local/share/glib-2.0/schemas"
cp -f "$CODE_DIR/forge/schemas/org.gnome.shell.extensions.forge.gschema.xml" \
      "$HOME_DIR/.local/share/glib-2.0/schemas/org.gnome.shell.extensions.forge.gschema.xml"
chmod 0644 "$HOME_DIR/.local/share/glib-2.0/schemas/org.gnome.shell.extensions.forge.gschema.xml"
glib-compile-schemas "$HOME_DIR/.local/share/glib-2.0/schemas/"

gset org.gnome.shell disable-user-extensions "false"
gset org.gnome.shell enabled-extensions "['forge@jmmaranan.com']"

gset org.gnome.shell.extensions.forge.keybindings window-focus-left  "['<Super>h']"
gset org.gnome.shell.extensions.forge.keybindings window-focus-down  "['<Super>j']"
gset org.gnome.shell.extensions.forge.keybindings window-focus-up    "['<Super>k']"
gset org.gnome.shell.extensions.forge.keybindings window-focus-right "['<Super>l']"
gset org.gnome.shell.extensions.forge.keybindings window-move-left   "['<Super><Shift>h']"
gset org.gnome.shell.extensions.forge.keybindings window-move-down   "['<Super><Shift>j']"
gset org.gnome.shell.extensions.forge.keybindings window-move-up     "['<Super><Shift>k']"
gset org.gnome.shell.extensions.forge.keybindings window-move-right  "['<Super><Shift>l']"
gset org.gnome.shell.extensions.forge.keybindings window-toggle-float "['<Super>comma']"

bash <<'CLEAN'
set -e
for schema in \
  org.gnome.desktop.wm.keybindings \
  org.gnome.shell.keybindings \
  org.gnome.mutter.keybindings \
  org.gnome.mutter.wayland.keybindings \
  org.gnome.settings-daemon.plugins.media-keys ; do
  for key in $(gsettings list-keys "$schema" 2>/dev/null); do
    [ "$key" = "custom-keybindings" ] && continue
    [ "$(gsettings range "$schema" "$key" 2>/dev/null)" = "type as" ] || continue
    gsettings set "$schema" "$key" "[]" 2>/dev/null || true
  done
done
gsettings set org.gnome.mutter overlay-key "" 2>/dev/null || true
CLEAN

gset org.gnome.desktop.wm.keybindings close            "['<Super><Shift>q']"
gset org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>f']"
for n in 1 2 3 4 5 6 7 8 9 10; do gset org.gnome.desktop.wm.keybindings "switch-to-workspace-$n" "['<Super>$n']"; done
for n in 1 2 3 4 5 6 7 8;      do gset org.gnome.desktop.wm.keybindings "move-to-workspace-$n"   "['<Super><Shift>$n']"; done

for n in 1 2 3 4 5 6 7 8 9; do gset org.gnome.shell.keybindings "switch-to-application-$n" "[]"; done
gset org.gnome.settings-daemon.plugins.media-keys lock-screen "[]"

gset org.gnome.mutter workspaces-only-on-primary "true"
gset org.gnome.mutter dynamic-workspaces "false"
gset org.gnome.desktop.wm.preferences num-workspaces "10"

gset org.gnome.shell.keybindings show-screenshot-ui "['<Super><Shift>s']"
gset org.gnome.settings-daemon.plugins.power idle-dim "false"
gset org.gnome.settings-daemon.plugins.color night-light-enabled "true"
gset org.gnome.settings-daemon.plugins.color night-light-schedule-from "19.0"
gset org.gnome.settings-daemon.plugins.color night-light-schedule-to "6.0"
gset org.gnome.desktop.background picture-uri      "'file://$CONFIGS_REPO/wallpapers/carnation-lily-lily-rose.jpg'"
gset org.gnome.desktop.background picture-uri-dark  "'file://$CONFIGS_REPO/wallpapers/zima-blue.png'"

gset org.gnome.shell disabled-extensions "['ding@rastersoft.com', 'ubuntu-dock@ubuntu.com']"

gset org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
  "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/',
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/',
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/',
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/',
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/',
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/',
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/']"

set_custom_kb() {
  local id="$1" name="$2" command="$3" binding="$4"
  local base="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$id/"
  gsettings set "$base" name "$name"
  gsettings set "$base" command "$command"
  gsettings set "$base" binding "$binding"
}
set_custom_kb custom0 "Terminal"  "/usr/bin/gtk-launch kitty.desktop"               "['<Super>t']"
set_custom_kb custom1 "Browser"   "/usr/bin/gtk-launch brave-browser.desktop"       "['<Super>b']"
set_custom_kb custom2 "Files"     "/usr/bin/gtk-launch org.gnome.Nautilus.desktop" "['<Super>e']"
set_custom_kb custom3 "Displays"  "/usr/bin/gnome-control-center display"           "['<Super>m']"
set_custom_kb custom4 "Lock"      "/usr/bin/loginctl lock-session"                   "['<Super><Shift>colon']"
set_custom_kb custom5 "Power off" "/usr/bin/gnome-session-quit --power-off --no-prompt" "['<Super><Ctrl><Alt>q']"
set_custom_kb custom6 "Reboot"    "/usr/bin/gnome-session-quit --reboot --no-prompt"    "['<Super><Ctrl><Alt>r']"

gset org.gnome.desktop.interface icon-theme        "'Yaru'"
gset org.gnome.desktop.interface gtk-theme         "'Adwaita'"
gset org.gnome.desktop.interface enable-animations "false"
gset org.gnome.desktop.interface clock-format      "'12h'"
gset org.gnome.desktop.peripherals.keyboard delay "150"
gset org.gnome.desktop.input-sources xkb-options   "['caps:none']"

xdg-settings set default-web-browser brave-browser.desktop
gset org.gnome.desktop.default-applications.terminal exec    "'kitty'"
gset org.gnome.desktop.default-applications.terminal exec-arg "''"

for m in video/mp4 video/x-msvideo video/quicktime video/x-matroska video/webm \
  video/x-flv video/x-ms-wmv video/mpeg video/ogg video/3gpp \
  audio/mpeg audio/flac audio/x-wav audio/ogg; do
  xdg-mime default vlc.desktop "$m"
done

sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator \
  "$HOME_DIR/.local/kitty.app/bin/kitty" 50 2>/dev/null || true

sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y python3-nautilus
sudo env DEBIAN_FRONTEND=noninteractive apt-get -y purge nautilus-extension-gnome-terminal 2>/dev/null || true

if ! dpkg -s nautilus-extension-any-terminal >/dev/null 2>&1; then
  [[ -f /tmp/nautilus-extension-any-terminal.deb ]] || \
    curl -fsSL -o /tmp/nautilus-extension-any-terminal.deb \
      https://github.com/Stunkymonkey/nautilus-open-any-terminal/releases/download/0.8.3/nautilus-extension-any-terminal_0.8.3-1_all.deb
  sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y /tmp/nautilus-extension-any-terminal.deb
fi
gset com.github.stunkymonkey.nautilus-open-any-terminal terminal "'kitty'"
nautilus -q 2>/dev/null || true

sudo mkdir -p /etc/systemd/logind.conf.d
sudo chmod 0755 /etc/systemd/logind.conf.d
tmp=$(mktemp)
cat > "$tmp" <<'EOF'
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalMonitors=ignore
HandleLidSwitchDocked=ignore
EOF
sudo install -m 0644 "$tmp" /etc/systemd/logind.conf.d/lid.conf
rm -f "$tmp"
