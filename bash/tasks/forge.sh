#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

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

gsettings set org.gnome.shell disable-user-extensions "false"
gsettings set org.gnome.shell enabled-extensions "['forge@jmmaranan.com']"

gsettings set org.gnome.shell.extensions.forge.keybindings window-focus-left  "['<Super>h']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-focus-down  "['<Super>j']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-focus-up    "['<Super>k']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-focus-right "['<Super>l']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-move-left   "['<Super><Shift>h']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-move-down   "['<Super><Shift>j']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-move-up     "['<Super><Shift>k']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-move-right  "['<Super><Shift>l']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-toggle-float "['<Super>comma']"

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

gsettings set org.gnome.desktop.wm.keybindings close            "['<Super><Shift>q']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>f']"
for n in 1 2 3 4 5 6 7 8 9 10; do gsettings set org.gnome.desktop.wm.keybindings "switch-to-workspace-$n" "['<Super>$n']"; done
for n in 1 2 3 4 5 6 7 8;      do gsettings set org.gnome.desktop.wm.keybindings "move-to-workspace-$n"   "['<Super><Shift>$n']"; done

for n in 1 2 3 4 5 6 7 8 9; do gsettings set org.gnome.shell.keybindings "switch-to-application-$n" "[]"; done
gsettings set org.gnome.settings-daemon.plugins.media-keys lock-screen "[]"

gsettings set org.gnome.mutter workspaces-only-on-primary "true"
gsettings set org.gnome.mutter dynamic-workspaces "false"
gsettings set org.gnome.desktop.wm.preferences num-workspaces "10"

gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super><Shift>s']"
gsettings set org.gnome.settings-daemon.plugins.power idle-dim "false"
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled "true"
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from "19.0"
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to "6.0"
gsettings set org.gnome.desktop.background picture-uri      "'file://$CONFIGS_REPO/wallpapers/carnation-lily-lily-rose.jpg'"
gsettings set org.gnome.desktop.background picture-uri-dark  "'file://$CONFIGS_REPO/wallpapers/zima-blue.png'"

gsettings set org.gnome.shell disabled-extensions "['ding@rastersoft.com', 'ubuntu-dock@ubuntu.com']"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
  "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/',
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/',
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/',
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/',
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/',
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/',
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/']"

kb_ids=(custom0 custom1 custom2 custom3 custom4 custom5 custom6)
kb_names=("Terminal" "Browser" "Files" "Displays" "Lock" "Power off" "Reboot")
kb_cmds=(
  "/usr/bin/gtk-launch kitty.desktop"
  "/usr/bin/gtk-launch brave-browser.desktop"
  "/usr/bin/gtk-launch org.gnome.Nautilus.desktop"
  "/usr/bin/gnome-control-center display"
  "/usr/bin/loginctl lock-session"
  "/usr/bin/gnome-session-quit --power-off --no-prompt"
  "/usr/bin/gnome-session-quit --reboot --no-prompt"
)
kb_binds=("['<Super>t']" "['<Super>b']" "['<Super>e']" "['<Super>m']" "['<Super><Shift>colon']" "['<Super><Ctrl><Alt>q']" "['<Super><Ctrl><Alt>r']")
for i in "${!kb_ids[@]}"; do
  base="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${kb_ids[$i]}/"
  gsettings set "$base" name    "${kb_names[$i]}"
  gsettings set "$base" command "${kb_cmds[$i]}"
  gsettings set "$base" binding "${kb_binds[$i]}"
done

gsettings set org.gnome.desktop.interface icon-theme        "'Yaru'"
gsettings set org.gnome.desktop.interface gtk-theme         "'Adwaita'"
gsettings set org.gnome.desktop.interface enable-animations "false"
gsettings set org.gnome.desktop.interface clock-format      "'12h'"
gsettings set org.gnome.desktop.peripherals.keyboard delay "150"
gsettings set org.gnome.desktop.input-sources xkb-options   "['caps:none']"

xdg-settings set default-web-browser brave-browser.desktop
gsettings set org.gnome.desktop.default-applications.terminal exec     "'kitty'"
gsettings set org.gnome.desktop.default-applications.terminal exec-arg "''"

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
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal "'kitty'"
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
