# containers/ros2-kilted/init.sh
# Run once after `distrobox create ros2-kilted` (Phase 6). Idempotent.
# Distinct default ROS_DOMAIN_ID (vs ros2-humble=10) to avoid cross-talk.
#!/usr/bin/env bash
set -euo pipefail

BOX="ros2-kilted"
DEFAULT_DOMAIN_ID=20
PX4_TAG="v1.15"

echo "[init] $BOX: setting defaults…"

cat > /etc/profile.d/ros-"$BOX".sh <<EOF
export ROS_LOCALHOST_ONLY=0
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export ROS_DOMAIN_ID=$DEFAULT_DOMAIN_ID
export PX4_PATH=\$HOME/code/PX4-Autopilot
EOF

if [ ! -d "$HOME/code/PX4-Autopilot" ]; then
  mkdir -p "$HOME/code"
  git clone --depth 1 --branch "$PX4_TAG" https://github.com/PX4/PX4-Autopilot.git \
    "$HOME/code/PX4-Autopilot"
fi

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
