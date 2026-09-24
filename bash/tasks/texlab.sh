#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

if [[ -d "$CODE_DIR/texlab/.git" ]]; then
  git -C "$CODE_DIR/texlab" fetch --all 2>/dev/null || true
  git -C "$CODE_DIR/texlab" reset --hard origin/HEAD 2>/dev/null || true
else
  git clone --depth 1 https://github.com/latex-lsp/texlab.git "$CODE_DIR/texlab"
fi

if [[ ! -x "$CODE_DIR/texlab/target/release/texlab" ]]; then
  bash -c "set -e; cd '$CODE_DIR/texlab'; '$CARGO_BIN/cargo' build --release"
fi

mkdir -p "$SOFTWARE_DIR/texlab"
cp -a "$CODE_DIR/texlab/target/release/." "$SOFTWARE_DIR/texlab/"

blockinfile "$BASHRC_FILE" "texlab-path" <<'EOF'
export PATH=$PATH:$HOME/.software/texlab
EOF
