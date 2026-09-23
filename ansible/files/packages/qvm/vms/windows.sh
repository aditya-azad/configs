# windows.sh — Windows VM spec, sourced by `qvm windows`.
# Funnels most of the host: cores,  ram.
# UEFI (OVMF) + swtpm TPM 2.0, virtio disk/net, full dGPU passthrough
# with a Looking-Glass framebuffer.
#
# GPU passthrough model (Ubuntu host):
#   • Normal boot → host owns the dGPU (NVIDIA driver, Hyprland, Steam).
#                   The VM cannot run.
#   • \"Ubuntu (Windows VFIO / Looking-Glass)\" grub entry → IOMMU on,
#     vfio-pci.ids=<dGPU>,<dGPU-audio>, nvidia blacklisted. Host renders on
#     the iGPU; the dGPU is reserved for the VM. grub entry created by
#     ansible/tasks/vfio.yml from the detected dGPU.
#
# First run (booted into the VFIO entry):
#   1. drop the Win11 ISO + virtio-win ISO into ~/.vms/windows (paths below;
#      override with VM_ISO=… / VM_DRIVERS_ISO=…)
#   2. qvm windows install     # create the disk + boot the installer
#      → \"Load driver\" → the USB-mounted virtio-win iso:
#        viostor\\*.inf, NetKVM, viogpudo — or the installer won't see the disk
#   3. inside Windows, install the Looking-Glass host app
#      (looking-glass-host.exe) so it captures the guest framebuffer into
#      the ivshmem region the launcher wires up.
#   4. qvm windows             # boot from disk thereafter
#   5. qvm windows kill        # stop
#
# Audio: a Bluetooth USB adapter (if detected) is passed through to Windows
# via VM_EXTRA_ARGS so it pairs the BT speaker directly — no audio
# virtualization. Host loses Bluetooth only while the VM runs; returns on
# `qvm windows kill`.
#
# Override per-run with env vars, e.g. `VM_ISO=… qvm windows install`.

# VM_OS is informational only (qvm does not branch on it).
VM_OS="win11"

# Hyper-V Enlightenments — set here so the qvm launcher stays OS-agnostic.
VM_CPU="host,hv_relaxed,hv_vapic,hv_time"

VM_DISK_GB="160"
VM_MEMORY_GB="16"            # fixed 16G for the Windows guest (qvm default is auto)
VM_FIRMWARE="uefi"
VM_TPM="1"                    # TPM 2.0 required by Win11

# Full dGPU passthrough + Looking-Glass shared-memory framebuffer. qvm wires
# the ivshmem device and launches looking-glass-client; the guest must run
# the Looking-Glass host app (step 3 above).
VM_GPU="vfio"
# dGPU + its audio PCI IDs (space-separated) — per-host, from vfio.yml via
# bashrc. Empty unless the `vfio` program has run on this host.
VM_VFIO_DEVS="${VM_VFIO_DEVS:-}"
VM_DISPLAY="looking-glass"
VM_IVSHMEM_SIZE="64"                  # MiB of shared framebuffer

# Install media — large ISOs live in ~/.vms/windows (VM_DIR), not in the repo.
# Override with `VM_ISO=… qvm windows install`.
VM_ISO="${VM_ISO:-$VM_DIR/Win11_24H2_English_x64.iso}"
VM_DRIVERS_ISO="${VM_DRIVERS_ISO:-$VM_DIR/virtio-win.iso}"

# Printed during `qvm windows install` if the drivers ISO is missing.
VM_INSTALL_NOTE="load virtio-win drivers (viostor, NetKVM, viogpudo) during install or the disk won't be visible"

# Extra QEMU args — per-host, from vfio.yml via bashrc. Passes the detected
# Bluetooth USB adapter through to Windows for direct BT-speaker audio.
# Empty on hosts with no BT adapter.
VM_EXTRA_ARGS="${VM_EXTRA_ARGS:-}"
