# windows.sh — Windows VM spec, sourced by `qvm windows`.
# Funnels most of the host: (nproc-4) cores, (total GiB - 8) ram.
# UEFI (OVMF) + swtpm-backed TPM 2.0, virtio disk/net/gpu over Spice.
#
# Managed by the configs-nix repo (home/packages/qvm/vms/windows.sh) and
# deployed read-only into ~/.vms/windows by home-manager. The mutable
# state (disk.qcow2, OVMF vars, sockets) is created in ~/.vms/windows on
# first run. qvm itself is OS-agnostic; everything Windows-specific lives
# here.
#
# First run:
#   1. drop the Win11 ISO + the virtio-win ISO somewhere (paths below)
#   2. qvm windows install     # create the disk + boot the installer
#      → "Load driver" → the USB-mounted virtio-win iso:
#        viostor\*.inf, NetKVM, viogpudo — or the installer won't see the disk
#   3. qvm windows             # boot from disk thereafter
#   4. qvm windows kill        # stop
#
# GPU passthrough: this host is hybrid Intel iGPU + NVIDIA dGPU, and the
# dGPU is owned by the host NVIDIA driver (Hyprland). Default is virtio-gpu
# over Spice. For vfio passthrough, bind the dGPU to vfio-pci at boot in
# nixos/modules/system.nix:
#   boot.kernelParams = [ "intel_iommu=on" "iommu=pt" "vfio-pci.ids=10de:2460,10de:2288" ];
#   boot.initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];
# then here set:
#   VM_GPU="vfio"; VM_VFIO_DEVS="10de:2460 10de:2288"
# (attach with looking-glass-client; ivshmem is not auto-wired by qvm.)
#
# Override per-run with env vars, e.g. `VM_ISO=… qvm windows install`.

# VM_OS is informational only (qvm does not branch on it).
VM_OS="win11"

# Hyper-V Enlightenments — Windows guests benefit from these; set here so
# the qvm launcher stays OS-agnostic (its default is just "host").
VM_CPU="host,hv_relaxed,hv_vapic,hv_time"

VM_DISK_GB="160"
VM_FIRMWARE="uefi"
VM_TPM="1"                    # TPM 2.0 required by Win11
VM_GPU="virtio"               # virtio-gpu over Spice (see above for vfio)

# Install media — large ISOs live in ~/.vms/windows (VM_DIR) alongside the
# disk; not committed to the repo. Override on the fly with
# `VM_ISO=… qvm windows install`.
VM_ISO="${VM_ISO:-$VM_DIR/Win11_24H2_English_x64.iso}"
VM_DRIVERS_ISO="${VM_DRIVERS_ISO:-$VM_DIR/virtio-win.iso}"

# Printed during `qvm windows install` if the drivers ISO is missing.
VM_INSTALL_NOTE="load virtio-win drivers (viostor, NetKVM, viogpudo) during install or the disk won't be visible"

VM_EXTRA_ARGS=""
