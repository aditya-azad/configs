#!/bin/bash

set -e

# system
gsettings set org.gnome.desktop.wm.keybindings close "['<Super><Shift>Q']"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super><Shift>s']"
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super><Shift>colon']"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
gsettings set org.gnome.desktop.background picture-uri "file:///home/${USER}/code/configs/wallpapers/cat-colorful.jpg"
gsettings set org.gnome.desktop.background picture-uri-dark "file:///home/${USER}/code/configs/wallpapers/cat-colorful.jpg"

# media keys
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Super>Return']"
gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Super>b']"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"

# moving windows
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-down "['<Super><Shift>j']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-up "['<Super><Shift>k']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-left "['<Super><Shift>h']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-right "['<Super><Shift>l']"

# tiling
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>k']"
gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Super>h']"
gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Super>l']"

# dock
gsettings set org.gnome.shell.extensions.dash-to-dock autohide false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
