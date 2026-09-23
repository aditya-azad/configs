# wallpaper setter — (re)write the Noctalia wallpaper config for the current
# theme so the new wallpaper loads. `st` sources this after swapping themes;
# it inherits $WALLPAPER (a bare filename in colors.conf) and $HOME from the
# parent. Noctalia hot-reloads its config on save, so no restart is needed.
#
# No-op on systems without noctalia (e.g. macOS, non-Noctalia hosts) so `st`
# stays portable — it just switches themes for the apps that are present.
command -v noctalia >/dev/null 2>&1 || return 0

# Noctalia reads every *.toml in ~/.config/noctalia/ and merges them; this
# file sorts after config.toml and so wins for [wallpaper.default]. Use the
# absolute path — Noctalia does not reliably expand `~` in wallpaper paths.
mkdir -p "$HOME/.config/noctalia"

cat > "$HOME/.config/noctalia/wallpaper.toml" <<EOF
[wallpaper]
directory = "$HOME/code/configs/wallpapers"

[wallpaper.default]
path = "$HOME/code/configs/wallpapers/$WALLPAPER"
EOF
