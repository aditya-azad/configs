# configs-nix

NixOS + Hyprland configuration for `legion-7i`, with all robotics + AI
workloads (ROS 2, PX4, CUDA, PyTorch) isolated in Distrobox containers.

This flake is **authored and built** on the dev box (Ubuntu + nix) and
**applied** to a separate NixOS host (`legion-7i`). Nothing on the dev box
needs to become NixOS.

See [`PLAN.md`](./PLAN.md) for the full migration design.

## Layout

```
flake.nix                         # identity (user/host/email) — single source of truth
hosts/legion-7i/
  default.nix                       # imports below
  hardware-configuration.nix        # generated on the target (Phase 0b)
  nvidia.nix                        # NVIDIA driver only
modules/
  system.nix                        # locale, time, users, fonts, nix, hyprland, logind
  container-runtime.nix             # docker + distrobox + nvidia-container-toolkit
home/
  home.nix                          # imports + xdg + package set
  shell.nix                         # bash: aliases, rdid, venvup, diary, SSH aliases
  hyprland.nix                      # keybinds, workspaces, env vars
  programs/                         # kitty, zellij, nvim, btop, git, refree
  services/syncthing.nix
  packages/                         # theme-switch (st), db launcher
  packages/theme-files/{light,dark}/
dotfiles/                           # existing configs, referenced by Home Manager
containers/
  registry.nix                      # name -> image, consumed by `db`
  ros2-humble/{Containerfile,distrobox.ini,init.sh}
  ros2-kilted/{Containerfile,distrobox.ini,init.sh}
```

## Workflow

### On the dev box (author + validate)

```bash
nix flake check
nix build .#nixosConfigurations.legion-7i.config.system.build.toplevel
```

No `nixos-rebuild switch` here — this box is not the target.

### On the target (`legion-7i`)

```bash
# 0b — first boot: generate the machine-specific hardware config
nixos-generate-config --root /mnt   # then copy hosts/legion-7i/hardware-configuration.nix
git clone <this-repo> ~/code/configs-nix   # or rsync

# apply the system + home-manager config
sudo nixos-rebuild switch --flake .#legion-7i
home-manager switch --flake .#legion-7i   # via the NixOS module, run as azada
```

### Containers

```bash
# build the OCI images on the host (one-time per box)
docker build -t localhost/ros2-humble:latest \
  -f containers/ros2-humble/Containerfile containers/ros2-humble
docker build -t localhost/ros2-kilted:latest \
  -f containers/ros2-kilted/Containerfile containers/ros2-kilted

# create + enter (the `db` launcher wraps distrobox with GPU passthrough)
db ros2-humble     # creates if absent, then enters
db                 # lists both boxes with created status
```

Inside a container:
```bash
ros2 topic list                              # ROS 2 works
~/code/PX4-Autopilot/Tools/simulation/gz/... # PX4 SITL launches
python -c "import torch; torch.cuda.is_available()"  # True
rdid 42                                       # live ROS_DOMAIN_ID change
```

### Theme switch

`st` is a real Nix derivation installed by Home Manager:
```bash
which st          # a store path
st               # flips Hyprland + kitty + btop + nvim
```

## Design principles

1. **Host is thin.** Kernel, NVIDIA driver, Hyprland, terminals/editors, container
   runtime. No languages/compilers/dev libraries on the host.
2. **Projects own their toolchain.** Each project declares the Python/CUDA/PyTorch
   it needs; the host never asserts a global one.
3. **Robotics lives in Distrobox.** `ros2-humble` and `ros2-kilted`, each with its
   own PX4 1.15 + CUDA + PyTorch.
4. **NVIDIA split.** Host owns the driver; containers own the CUDA toolkit.
5. **Declarative & reproducible.** Flake + Home Manager.
