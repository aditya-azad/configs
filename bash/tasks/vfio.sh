#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

jget() { printf '%s' "$vfio_json" | sed -n 's/.*"'"$1"'":"\([^"]*\)".*/\1/p'; }

vfio_json="$(bash <<'DETECT'
set -uo pipefail
cv=$(awk -F: '/^vendor_id/{gsub(/ /,"",$2); print tolower($2); exit}' /proc/cpuinfo)
case "$cv" in
  *amd*) iommu="amd_iommu=on iommu=pt" ;;
  *)     iommu="intel_iommu=on iommu=pt" ;;
esac

gpu_line=$(lspci -nn | grep -iE 'VGA compatible|3D controller' | grep -i nvidia | head -1 || true)
gpu_bdf=$(printf '%s' "$gpu_line" | awk '{print $1}')
gpu_ids=$(printf '%s' "$gpu_line" | grep -oE '\[[0-9a-f]{4}:[0-9a-f]{4}\]' | tail -1 | tr -d '[]')
bd=$(printf '%s' "$gpu_bdf" | awk -F. '{print $1}')

audio_line=$(lspci -nn -d 10de::0403 \
  | awk -v bd="$bd" 'bd != "" && $1 ~ "^"bd"\\." {print}' | head -1 || true)
audio_ids=$(printf '%s' "$audio_line" | grep -oE '\[[0-9a-f]{4}:[0-9a-f]{4}\]' | tail -1 | tr -d '[]')

igpu_line=$(lspci -nn -d ::0300 | grep -iv nvidia | head -1 || true)
igpu_bdf=$(printf '%s' "$igpu_line" | awk '{print $1}')

bt_v=""; bt_p=""
for link in /sys/class/bluetooth/*/device; do
  [ -e "$link" ] || continue
  dev=$(readlink -f "$link")
  case "$dev" in */usb*) ;; *) continue ;; esac
  while [ "$dev" != "/" ] && [ -n "$dev" ] && [ ! -f "$dev/idVendor" ]; do
    dev=$(dirname "$dev")
  done
  if [ -f "$dev/idVendor" ]; then
    bt_v=$(cat "$dev/idVendor"  2>/dev/null || true)
    bt_p=$(cat "$dev/idProduct" 2>/dev/null || true)
    break
  fi
done

bypath() { printf '/dev/dri/by-path/pci-0000:%s-card' "$1"; }
drm=""
if [ -n "$igpu_bdf" ] && [ -n "$gpu_bdf" ]; then
  drm="$(bypath "$gpu_bdf"):$(bypath "$igpu_bdf")"
fi

vfio_ids="$gpu_ids"
if [ -n "$audio_ids" ] && [ -n "$gpu_ids" ]; then vfio_ids="$gpu_ids,$audio_ids"; fi

bt_extra=""
if [ -n "$bt_v" ] && [ -n "$bt_p" ]; then
  bt_extra="-device usb-host,vendorid=0x$bt_v,productid=0x$bt_p"
fi

printf '{"iommu":"%s","gpu_bdf":"%s","gpu_ids":"%s","audio_ids":"%s","vfio_ids":"%s","igpu_bdf":"%s","drm":"%s","bt_vendor":"%s","bt_product":"%s","bt_extra":"%s"}\n' \
  "$iommu" "$gpu_bdf" "$gpu_ids" "$audio_ids" "$vfio_ids" "$igpu_bdf" "$drm" "$bt_v" "$bt_p" "$bt_extra"
DETECT
)"

vfio_iommu="$(jget iommu)"
vfio_gpu_bdf="$(jget gpu_bdf)"
vfio_vfio_ids="$(jget vfio_ids)"
vfio_igpu_bdf="$(jget igpu_bdf)"
vfio_drm="$(jget drm)"
vfio_bt_vendor="$(jget bt_vendor)"
vfio_bt_product="$(jget bt_product)"
vfio_bt_extra="$(jget bt_extra)"

echo "!! dGPU=$vfio_gpu_bdf ids=$vfio_vfio_ids; iGPU=$vfio_igpu_bdf; IOMMU=$vfio_iommu; BT=$vfio_bt_vendor:$vfio_bt_product; AQ_DRM_DEVICES=$vfio_drm" >&2

if [[ -z "$vfio_vfio_ids" ]]; then
  echo "xx vfio: no NVIDIA dGPU detected (lspci: no VGA/3D controller with vendor 10de). The vfio program only makes sense on a host with an NVIDIA dGPU." >&2
  exit 1
fi
if [[ -z "$vfio_igpu_bdf" ]]; then
  echo "xx vfio: no iGPU (non-NVIDIA VGA controller) found. This Looking-Glass setup needs a dual-GPU host. Remove vfio from this host's programs." >&2
  exit 1
fi

sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y "linux-modules-extra-$KERNEL"

sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential cmake ninja-build git pkg-config \
  libegl-dev libegl1-mesa-dev libgl1-mesa-dev libgles-dev libpulse-dev \
  libpipewire-0.3-dev libwayland-dev wayland-protocols libx11-dev \
  libxfixes-dev libxi-dev libxpresent-dev libxscrnsaver-dev libxinerama-dev \
  libxcursor-dev libxss-dev libxrandr-dev libfontconfig-dev fonts-freefont-ttf

lg_tag="B6"
lg_src="$HOME_DIR/.local/src/looking-glass"
lg_bin="$HOME_DIR/.local/bin/looking-glass-client"
lg_marker="$HOME_DIR/.local/share/.looking-glass.tag"

lg_installed=""
[[ -f "$lg_marker" ]] && lg_installed="$(cat "$lg_marker")"

if [[ "$lg_installed" != "$lg_tag" || ! -x "$lg_bin" ]]; then
  mkdir -p "$lg_src" "$lg_src/client/build"
  chmod 0755 "$lg_src" "$lg_src/client/build"
  if [[ -d "$lg_src/.git" ]]; then
    git -C "$lg_src" fetch --all --tags 2>/dev/null || true
    git -C "$lg_src" checkout "$lg_tag" 2>/dev/null || true
  else
    git clone --depth 1 --branch "$lg_tag" https://looking-glass.io/git/looking-glass.git "$lg_src"
  fi
  bash -c "set -e; cd '$lg_src/client/build'; cmake -G Ninja -DENABLE_PULSEAUDIO=ON -DENABLE_PIPEWIRE=ON .."
  bash -c "set -e; cd '$lg_src/client/build'; cmake --build . --parallel $NPROC"
  cp -f "$lg_src/client/build/looking-glass-client" "$lg_bin"
  chmod 0755 "$lg_bin"
  printf '%s\n' "$lg_tag" > "$lg_marker"
  chmod 0644 "$lg_marker"
fi

boot_fs_uuid="$(sudo grub-probe --target=fs_uuid /boot)"
boot_image="$(awk -F= '$1=="BOOT_IMAGE"{gsub(/"/,"",$2); print $2}' /proc/cmdline)"
root_arg="$(awk -F= '$1=="root"{gsub(/"/,"",$2); print $2}' /proc/cmdline)"
initrd="${boot_image/vmlinuz/initrd.img}"

grub_entry="/etc/grub.d/40_windows_vfio"
grub_new="$(mktemp)"
cat > "$grub_new" <<EOF
#!/bin/sh
exec tail -n +3 "\$0"
# Managed by configs (bash/tasks/vfio.sh) — do not edit by hand.
# Reserves the NVIDIA dGPU + its audio ($vfio_vfio_ids) for the Windows
# VM via vfio-pci and keeps nvidia off the dGPU this boot only.
# Boot the normal "Ubuntu" entry to give the dGPU back to the host.
menuentry "Ubuntu (Windows VFIO / Looking-Glass)" {
    search --no-floppy --fs-uuid --set=root $boot_fs_uuid
    linux $boot_image root=$root_arg ro $vfio_iommu pcie_acs_override=downstream vfio-pci.ids=$vfio_vfio_ids module_blacklist=nvidia,nvidia_drm,nvidia_modeset,nvidia_uvm,nvidia_wmi_ec_backlight
    initrd $initrd
}
EOF
chmod 0755 "$grub_new"
grub_changed=0
if [[ ! -f "$grub_entry" ]]; then
  grub_changed=1
elif ! diff -q "$grub_new" "$grub_entry" >/dev/null 2>&1; then
  grub_changed=1
fi
if [[ "$grub_changed" == 1 ]]; then
  sudo mv "$grub_new" "$grub_entry"
  sudo update-grub
else
  rm -f "$grub_new"
fi

vfio_devs="${vfio_vfio_ids//,/ }"
blockinfile "$BASHRC_FILE" "qvm-vfio" <<EOF
export VM_VFIO_DEVS="$vfio_devs"
export VM_EXTRA_ARGS="$vfio_bt_extra"
EOF

mkdir -p "$HOME_DIR/.config/environment.d"
chmod 0755 "$HOME_DIR/.config/environment.d"
printf 'AQ_DRM_DEVICES=%s\n' "$vfio_drm" > "$HOME_DIR/.config/environment.d/hypr-drm.conf"
chmod 0644 "$HOME_DIR/.config/environment.d/hypr-drm.conf"

if [[ -n "$vfio_bt_vendor" ]]; then
  udev_rule="/etc/udev/rules.d/99-qvm-bluetooth.rules"
  udev_new="$(mktemp)"
  cat > "$udev_new" <<EOF
# Managed by configs (bash/tasks/vfio.sh) — do not edit by hand.
# Let $USERNAME pass the Bluetooth USB adapter
# ($vfio_bt_vendor:$vfio_bt_product) to the Windows VM via
# QEMU usb-host for direct BT-speaker audio.
SUBSYSTEM=="usb", ATTRS{idVendor}=="$vfio_bt_vendor", ATTRS{idProduct}=="$vfio_bt_product", OWNER="$USERNAME", MODE="0660"
EOF
  udev_changed=0
  if [[ ! -f "$udev_rule" ]]; then
    udev_changed=1
  elif ! diff -q "$udev_new" "$udev_rule" >/dev/null 2>&1; then
    udev_changed=1
  fi
  if [[ "$udev_changed" == 1 ]]; then
    sudo mv "$udev_new" "$udev_rule"
    sudo chmod 0644 "$udev_rule"
    sudo udevadm control --reload-rules
    sudo udevadm trigger --subsystem-match=usb \
      --attr-match=idVendor="$vfio_bt_vendor" \
      --attr-match=idProduct="$vfio_bt_product"
  else
    rm -f "$udev_new"
  fi
fi
