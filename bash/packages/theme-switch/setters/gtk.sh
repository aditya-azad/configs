# gtk setter — flip the GNOME/GTK color-scheme so GTK apps and
# xdg-desktop-portal follow the `st` dark/light toggle. $POLARITY comes from
# the theme's colors.conf ("dark" or "light").
#
# No-op where gsettings isn't available (e.g. macOS) so `st` stays portable.
command -v gsettings >/dev/null 2>&1 || return 0
gsettings set org.gnome.desktop.interface color-scheme "prefer-$POLARITY" 2>/dev/null || true