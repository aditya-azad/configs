# containers/ros2-humble/init.sh
# Run once after `distrobox create ros2-humble` (Phase 6). Idempotent.
# Sets up the per-container ROS env defaults (distinct domain ID to avoid
# cross-talk), PX4 checkout, and Cyclone DDS config.
#!/usr/bin/env bash
set -euo pipefail

BOX="ros2-humble"
DEFAULT_DOMAIN_ID=10                       # distinct per container; rdid adjusts live
PX4_TAG="v1.15"

echo "[init] $BOX: setting defaults…"

# ── ROS env defaults (written to /etc/profile.d so every shell picks them up) ──
cat > /etc/profile.d/ros-"$BOX".sh <<EOF
export ROS_LOCALHOST_ONLY=0
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export ROS_DOMAIN_ID=$DEFAULT_DOMAIN_ID
export PX4_PATH=\$HOME/code/PX4-Autopilot
EOF

# ── PX4 1.15 checkout (built inside the container) ────────────────────────────
if [ ! -d "$HOME/code/PX4-Autopilot" ]; then
  mkdir -p "$HOME/code"
  git clone --depth 1 --branch "$PX4_TAG" https://github.com/PX4/PX4-Autopilot.git \
    "$HOME/code/PX4-Autopilot"
fi

# ── Cyclone DDS config defaults (multicast on the LAN) ────────────────────────
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

echo "[init] $BOX ready. Re-enter with: distrobox enter $BOX"
