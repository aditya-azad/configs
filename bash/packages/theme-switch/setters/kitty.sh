command -v kitty >/dev/null 2>&1 || return 0
mkdir -p "$HOME/.config/kitty"
cp "$STATE_DIR/current/kitty.conf" "$HOME/.config/kitty/theme.conf"
pkill -USR1 -x kitty 2>/dev/null || true
