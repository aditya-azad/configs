#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y \
  ninja-build gettext cmake unzip curl build-essential

if [[ -d "$CODE_DIR/neovim/.git" ]]; then
  git -C "$CODE_DIR/neovim" fetch --all --tags 2>/dev/null || true
  git -C "$CODE_DIR/neovim" checkout master 2>/dev/null || true
  git -C "$CODE_DIR/neovim" reset --hard origin/master 2>/dev/null || true
else
  git clone --depth 1 https://github.com/neovim/neovim "$CODE_DIR/neovim"
fi

nvim_head="$(git -C "$CODE_DIR/neovim" rev-parse HEAD)"
nvim_installed=""
[[ -f /usr/local/share/nvim-commit ]] && nvim_installed="$(cat /usr/local/share/nvim-commit)"

if [[ "$nvim_head" != "$nvim_installed" || ! -x /usr/local/bin/nvim ]]; then
  rm -rf "$CODE_DIR/neovim/build"
  sudo rm -f /usr/local/bin/nvim
  sudo rm -rf /usr/local/share/nvim /usr/local/lib/nvim /usr/local/share/nvim-commit
  bash -c "set -e; cd '$CODE_DIR/neovim'; make CMAKE_BUILD_TYPE=RelWithDebInfo"
  sudo make -C "$CODE_DIR/neovim" install
  printf '%s\n' "$nvim_head" | sudo tee /usr/local/share/nvim-commit >/dev/null
  sudo chmod 0644 /usr/local/share/nvim-commit
fi

mkdir -p "$HOME_DIR/.config"
chmod 0755 "$HOME_DIR/.config"
ln -sfn "$CONFIGS_REPO/nvim" "$HOME_DIR/.config/nvim"
