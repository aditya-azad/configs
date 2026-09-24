# wallpaper setter — (re)write hyprpaper config for the current theme and
# restart hyprpaper so the new wallpaper loads. `st` sources this after
# swapping themes; it inherits $WALLPAPER (a bare filename in colors.conf) and
# $HOME from the parent.
#
# No-op on systems without hyprpaper (e.g. macOS, non-Hyprland hosts) so `st`
# stays portable — it just switches themes for the apps that are present.
command -v hyprpaper >/dev/null 2>&1 || return 0

# hyprpaper reads ~/.config/hypr/hyprpaper.conf by default. Unlike Hyprland,
# hyprpaper does NOT use the hyprlang `wallpaper[*] { path = ... }` category
# form — it uses flat `preload =` and `wallpaper = monitor,path` directives.
# An empty monitor means the default/first output.
mkdir -p "$HOME/.config/hypr"

# Wallpapers live in the configs repo. Use the absolute path — hyprpaper does
# not reliably expand `~`.
WP_PATH="$HOME/code/configs/wallpapers/$WALLPAPER"
cat > "$HOME/.config/hypr/hyprpaper.conf" <<EOF
preload = $WP_PATH
wallpaper = ,$WP_PATH
EOF

systemctl --user restart hyprpaper 2>/dev/null || true