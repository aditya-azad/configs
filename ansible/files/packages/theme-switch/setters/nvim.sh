command -v nvim >/dev/null 2>&1 || return 0
mkdir -p "$DOTFILES_DIR/nvim/lua"
cp "$STATE_DIR/current/nvim.lua" "$DOTFILES_DIR/nvim/lua/theme.lua"
