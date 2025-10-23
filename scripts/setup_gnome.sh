#!/bin/bash

set -e

# system
gnome-extensions disable ubuntu-dock@ubuntu.com
gsettings set org.gnome.desktop.wm.keybindings close "['<Super><Shift>Q']"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super><Shift>s']"
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super><Shift>colon']"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
gsettings set org.gnome.desktop.interface icon-theme Yaru
gsettings set org.gnome.desktop.interface gtk-theme Adwaita
gsettings set org.gnome.desktop.background picture-uri "file:///home/${USER}/code/configs/wallpapers/wyeth-christinas-world.jpg"
gsettings set org.gnome.desktop.background picture-uri-dark "file:///home/${USER}/code/configs/wallpapers/cat-colorful.jpg"
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.peripherals.keyboard delay 150
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.power lid-close-suspend-with-external-monitor false
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 19
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 6
gsettings set org.gnome.desktop.interface clock-format '12h'

# media keys and apps
xdg-settings set default-web-browser brave-browser.desktop
gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'
gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''
gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Super>b']"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"

# windows
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>m']"

gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-down "['<Super><Shift>j']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-up "['<Super><Shift>k']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-left "['<Super><Shift>h']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-right "['<Super><Shift>l']"

gsettings set org.gnome.shell.keybindings switch-to-application-1 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-2 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-3 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-4 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-5 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-6 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-7 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-8 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-9 "[]"

# workspace
gsettings set org.gnome.mutter workspaces-only-on-primary true
gsettings set org.gnome.desktop.wm.preferences num-workspaces 10
gsettings set org.gnome.mutter dynamic-workspaces false

gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>5']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>6']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 "['<Super><Shift>7']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 "['<Super><Shift>8']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-9 "['<Super><Shift>9']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>0']"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>7']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Super>8']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "['<Super>9']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"

# custom
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
## shut down
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Shutdown'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'systemctl poweroff'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super><Ctrl><Alt>q'
## restart
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Restart'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'systemctl reboot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Super><Ctrl><Alt>r'

# dock
gsettings set org.gnome.shell.extensions.dash-to-dock autohide false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false

# popshell
export GSETTINGS_SCHEMA_DIR="$HOME/.local/share/gnome-shell/extensions/pop-shell@system76.com/schemas/"
gsettings set org.gnome.shell.extensions.pop-shell active-hint true
gsettings set org.gnome.shell.extensions.pop-shell active-hint-border-radius 0
gsettings set org.gnome.shell.extensions.pop-shell gap-outer 2
gsettings set org.gnome.shell.extensions.pop-shell gap-inner 2
gsettings set org.gnome.shell.extensions.pop-shell show-title false

