# gtk setter — flip the GNOME/GTK color-scheme so GTK apps and
# xdg-desktop-portal follow the `st` dark/light toggle. $POLARITY comes from
# the theme's colors.conf ("dark" or "light").
#
# GTK3 apps (e.g. Thunar) ignore color-scheme on their own, so also switch the
# GTK3 theme to adw-gtk3{,-dark}. Install the generated palette accent override
# to gtk-{3,4}.0/gtk.css.
#
# No-op where gsettings isn't available (e.g. macOS) so `st` stays portable.
command -v gsettings >/dev/null 2>&1 || return 0

gsettings set org.gnome.desktop.interface color-scheme "prefer-$POLARITY" 2>/dev/null || true

case "$POLARITY" in
  dark)  gtk_theme="adw-gtk3-dark" ;;
  light) gtk_theme="adw-gtk3" ;;
  *)     gtk_theme="adw-gtk3" ;;
esac
gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme" 2>/dev/null || true

[[ -f "$STATE_DIR/current/gtk.css" ]] || return 0
for v in gtk-3.0 gtk-4.0; do
  mkdir -p "$DOTFILES_DIR/$v"
  cp -f "$STATE_DIR/current/gtk.css" "$DOTFILES_DIR/$v/gtk.css"
done