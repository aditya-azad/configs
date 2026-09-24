command -v swaybg >/dev/null 2>&1 || return 0

WP_PATH="$HOME/code/configs/wallpapers/$WALLPAPER"
[ -f "$WP_PATH" ] || return 0

mkdir -p "$STATE_DIR/current"
printf '%s\n' "$WP_PATH" > "$STATE_DIR/current/wallpaper"

systemctl --user restart swaybg 2>/dev/null || true
