#!/usr/bin/env bash
# init.sh — runs automatically on every enter via distrobox --init-hooks.
# Idempotent: PX4 checkout + Cyclone DDS config. Safe to re-run.
set -euo pipefail

PX4_TAG="${PX4_TAG:-v1.15}"

# PX4 1.15 checkout (shallow clone into the shared $HOME)
if [ ! -d "$HOME/code/PX4-Autopilot" ]; then
  mkdir -p "$HOME/code"
  git clone --depth 1 --branch "$PX4_TAG" https://github.com/PX4/PX4-Autopilot.git \
    "$HOME/code/PX4-Autopilot" || echo "[init] PX4 clone failed — will retry next enter"
fi

# Cyclone DDS config (multicast on the LAN)
mkdir -p "$HOME/.config/cyclonedds"
cat > "$HOME/.config/cyclonedds/cyclonedds.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8" ?>
<cyclonedds xmlns="https://cdds.io/config">
  <domain id="any">
    <general>
      <allowMulticast>spdp</allowMulticast>
    </general>
  </domain>
</cyclonedds>
EOF
