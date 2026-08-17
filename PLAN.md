# NixOS Migration Plan — Hyprland + Distrobox

Migrate the Ubuntu 22.04 / GNOME / Pop-Shell desktop config in this repo to a
NixOS host running Hyprland, with all robotics + AI workloads (ROS 2, PX4,
CUDA, PyTorch) isolated in Distrobox containers.

> **Build vs. deploy.** This flake is authored and evaluated on the current
> Ubuntu + nix machine (nix is already installed here); it is *applied* to a
> separate, dedicated NixOS host — `legion-7i`. Phase 0 describes that
> target's bootstrap. Nothing on this dev box needs to become NixOS.

## Design principles

1. **Host is thin.** It provides the kernel, NVIDIA driver, the Wayland
   compositor (Hyprland), terminals/editors, and the container runtime. It
   installs **no** programming languages, compilers, or development
   libraries. Python, Rust, Go, Node, CUDA toolkit, PyTorch, ROS 2, PX4 —
   none of these live on the host.
2. **Projects own their toolchain.** Each project declares the languages,
   PyTorch, and CUDA version it needs. The host never asserts a global
   Python/CUDA.
3. **Robotics lives in Distrobox.** Two containers, one per ROS 2 distro:
   `ros2-humble` and `ros2-kilted`. Each carries its own PX4 1.15 and its own
   CUDA + PyTorch.
4. **NVIDIA split.** Host owns the *driver*; containers own the *CUDA
   toolkit* matching their PyTorch build. GPU access flows through
   `nvidia-container-toolkit` (host) + `distrobox --nvidia` (container).
5. **Declarative & reproducible.** Flake + Home Manager; the shell
   aliases, theme switcher, and dotfile symlinks become Nix modules, not
   hand-run bash.

## Target layout

```
configs-nix/
  flake.nix             # identity (user/host/email) lives here — single source of truth
  hosts/
    legion-7i/
      default.nix          # imports below
      hardware-configuration.nix   # generated: filesystems, boot
      nvidia.nix           # NVIDIA driver only (no container/Hyprland env here)
  modules/
    system.nix            # locale, time, users, fonts, nix settings
    container-runtime.nix # docker + distrobox + nvidia-container-toolkit
  home/
    home.nix             # imports + xdg + dconf fallback
    shell.nix            # bash: aliases, rdid, venvup, diary, SSH aliases
    programs/
      kitty.nix
      zellij.nix
      nvim.nix            # imports existing init.lua + lua/
      btop.nix
      git.nix
      refree.nix
    hyprland.nix          # keybinds, workspaces, exec, env vars
    packages/
      theme-switch.nix     # `st` app — toggles hyprland/kitty/btop/nvim theme
      db.nix               # `db` app — list/enter distrobox containers
    services/
      syncthing.nix        # systemd user unit + config
    ros2-humble/
      Containerfile
      distrobox.ini
      init.sh
    ros2-kilted/
      Containerfile
      distrobox.ini
      init.sh
  dotfiles/              # existing configs, referenced by Home Manager
    nvim/  kitty/  zellij/  btop/  wallpapers/
```

---

## Phase 0 — Author the config here, install NixOS on `legion-7i`

This repo lives on the dev box (Ubuntu + nix). All configuration is
*authored and built* here, then *copied to `legion-7i`* where it is actually
installed. Phase 0 is two tracks that converge when the target is handed
the flake.

### 0a — On the dev box (this machine, nix already installed)

- Scaffold the flake: `flake.nix` with the `identity` `let` binding (single
  source of truth — see Phase 5), passed to modules via `specialArgs`.
  Wire `networking.hostName` + the `nixosConfigurations.legion-7i` key from
  `identity`; hostname and flake output can't drift apart.
- Stand up the module tree (empty-but-valid): `hosts/legion-7i/default.nix`,
  `modules/system.nix`, `hosts/legion-7i/nvidia.nix`, `home/`, `containers/`.
  Leave `hardware-configuration.nix` as a placeholder import — it is
  machine-specific and generated on the target (0b).
- Build, don't switch: `nix flake check` and
  `nix build .#nixosConfigurations.legion-7i.config.system.build.toplevel`
  to validate the config evaluates against the target's `system` arch
  (set `nixpkgs.hostPlatform` in the host module; cross-build if the dev
  box and `legion-7i` differ in arch). No `nixos-rebuild switch` here —
  this box is not the target.
- Push the config: commit to git and clone (or `rsync`) the repo onto
  `legion-7i` once it exists (0b).

### 0b — On the target (`legion-7i`, NixOS not yet installed)

- Install NixOS 24.11+ (or unstable) with flakes enabled — minimal ISO,
  GUI-less, to a TTY.
- Generate `hardware-configuration.nix` on the target
  (`nixos-generate-config`) and drop it in at
  `hosts/legion-7i/hardware-configuration.nix` (pull it back into the repo,
  or generate in-place after cloning).
- Pull the repo and run the real apply:
  `nixos-rebuild switch --flake .#legion-7i`. This brings in `system.nix`
  + `nvidia.nix` + Home Manager; boot to a working TTY with networking
  first, GUI comes in later phases.

**Acceptance:** `0a` — `nix flake check` is green and the toplevel builds
on the dev box without touching it. `0b` — `nixos-rebuild switch --flake
.#legion-7i` on `legion-7i` boots to a working TTY with networking, with
the config authored in this repo.

## Phase 1 — NVIDIA driver + container runtime

`nvidia.nix` (host):
```nix
services.xserver.videoDrivers = [ "nvidia" ];
hardware.nvidia = {
  modesetting.enable = true;
  open = false;                       # 570+ closed, until open kernels match
  package = config.boot.kernelPackages.nvidiaPackages.beta; # or stable
  powerManagement.enable = true;
  nvidiaSettings = true;
};
boot.kernelParams = [ "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1" ];
```

`container-runtime.nix`:
```nix
virtualisation.docker = {
  enable = true;                     # distrobox runtime
  enableOnBoot = true;
  liveRestore = true;
  storageDriver = "overlay2";
  daemonSettings = {
    data-root = "/var/lib/docker";   # move to a big disk if needed
    features = { buildkit = true; };
  };
};
virtualisation.containers.enable = true;
hardware.nvidia-container-toolkit.enable = true;   # GPU passthrough
environment.systemPackages = [ pkgs.distrobox pkgs.docker-compose ];
# azada in docker group so `docker`/distrobox run without sudo
users.users.${identity.user}.extraGroups = [ "docker" ];

# distrobox default runtime = docker (per-box override via distrobox.ini)
environment.etc."distrobox/distrobox.conf".text = ''
  container_manager="docker"
'';
```

`docker run --gpus all` and `distrobox --nvidia` share the same
`nvidia-container-toolkit` → host driver; no CUDA toolkit on the host.

**Acceptance:** `distrobox enter` into a throwaway container and run
`nvidia-smi` (shows host GPU) — no CUDA toolkit on host, just driver.

## Phase 2 — Hyprland + base desktop

`hyprland.nix` (host or home-manager module):
```nix
programs.hyprland.enable = true;
# NVIDIA Hyprland env (set in home hyprland.nix via env=):
#   LIBVA_DRIVER_NAME,nvidia
#   __GLX_VENDOR_LIBRARY_NAME,nvidia
#   WLR_NO_HARDWARE_CURSORS,1
```
Every gsettings entry in `scripts/setup_gnome.sh` is reproduced below as a
Hyprland/NixOS equivalent — **same key combos, analogous action**. Keybinds
live in Home Manager's `wayland.windowManager.hyprland.settings`
(`home/hyprland.nix`); non-keybind settings map to Hyprland config blocks,
NixOS options, or small user services. `setup_gnome.sh` + `install_popshell.sh`
retire (Pop Shell tiling → Hyprland native tiling).

### gsettings → Hyprland / NixOS mapping

| GNOME (`setup_gnome.sh`)                       | Hyprland / NixOS equivalent |
|-----------------------------------------------|-----------------------------|
| close `<Super><Shift>Q`                        | `bind = SUPER SHIFT, Q, killactive,` |
| show-screenshot-ui `<Super><Shift>s`            | `bind = SUPER SHIFT, S, exec, grimblast save area - \| wl-copy` |
| screensaver `<Super><Shift>colon`              | `bind = SUPER SHIFT, colon, exec, loginctl lock-session` (or `hyprlock`) |
| media-key www `<Super>b`                       | `bind = SUPER, B, exec, brave` |
| media-key home `<Super>e`                      | `bind = SUPER, E, exec, nautilus` |
| toggle-maximized `<Super>f`                    | `bind = SUPER, F, fullscreen, 1` (maximize) |
| move-to-monitor h/j/k/l `<Super><Shift>`       | `bind = SUPER SHIFT, H/J/K/L, movewindow, l/d/u/r` |
| switch-to-workspace 1..10 `<Super>1..0`        | `bind = SUPER, 1..9/0, workspace, 1..10` |
| move-to-workspace 1..10 `<Super><Shift>1..0`   | `bind = SUPER SHIFT, 1..9/0, movetoworkspace, 1..10` |
| switch-to-application 1..9 `[]` (disabled)     | no bind (GNOME-only) |
| custom shutdown `<Super><Ctrl><Alt>q`          | `bind = SUPER CTRL ALT, Q, exec, systemctl poweroff` |
| custom restart `<Super><Ctrl><Alt>r`           | `bind = SUPER CTRL ALT, R, exec, systemctl reboot` |
| caps:none                                       | `input.xkb_options = "caps:none"` |
| keyboard delay 150                              | `input.repeat_delay = 150` |
| enable-animations false                         | `animations.enabled = false` |
| popshell gap-inner 2 / gap-outer 2             | `general.gaps_in = 2; general.gaps_out = 2` |
| popshell active-hint true, border-radius 0    | `general.border_size = 2; decoration.rounding = 0` |
| popshell show-title true                       | `waybar` title module |
| num-workspaces 10, dynamic-workspaces false    | 10 persistent `workspace =` entries |
| workspaces-only-on-primary                     | n/a — Hyprland workspaces are per-monitor |
| night-light 19→6                               | `services.gammastep` user unit (HM) |
| idle-dim false                                  | nothing (Hyprland doesn't dim) |
| lid-close nothing (ac/battery/external)        | NixOS `services.logind.lidSwitch* = "ignore"` |
| clock-format 12h                                | `waybar` clock `format = "{:%I:%M %p}"` |
| default web-browser brave                       | `xdg.mimeApps` (HM) |
| default terminal kitty                         | binds use `kitty` directly; nautilus via `xdg.configFile` |
| background carnation (light) / zima-blue (dark) | `hyprpaper`; `st` (Phase 4) swaps both |
| dock autohide/disabled                          | no dock (`waybar` optional) |

### `home/hyprland.nix`

```nix
{ identity, pkgs, lib, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # NVIDIA env — lives here, NOT in nvidia.nix
      env = [ "LIBVA_DRIVER_NAME,nvidia" "__GLX_VENDOR_LIBRARY_NAME,nvidia"
              "WLR_NO_HARDWARE_CURSORS,1" ];
      input  = { xkb_options = "caps:none"; repeat_delay = 150; };
      general = { gaps_in = 2; gaps_out = 2; border_size = 2; };
      decoration = { rounding = 0; };           # popshell active-hint-border-radius 0
      animations = { enabled = false; };
      # 10 persistent workspaces (num-workspaces 10, dynamic-workspaces false)
      workspace = map toString (lib.range 1 10);
      bind = [
        "SUPER, Return, exec, kitty"                       # default terminal kitty
        "SUPER, B, exec, brave"                            # www Super+b
        "SUPER, E, exec, nautilus"                         # home Super+e
        "SUPER, F, fullscreen, 1"                          # toggle-maximized Super+f
        "SUPER SHIFT, Q, killactive,"                      # close Super+Shift+Q
        "SUPER SHIFT, S, exec, grimblast save area - | wl-copy"   # screenshot
        "SUPER SHIFT, colon, exec, loginctl lock-session"   # screensaver
        "SUPER CTRL ALT, Q, exec, systemctl poweroff"      # custom shutdown
        "SUPER CTRL ALT, R, exec, systemctl reboot"        # custom restart
        "SUPER SHIFT, H, movewindow, l"  "SUPER SHIFT, J, movewindow, d"
        "SUPER SHIFT, K, movewindow, u"  "SUPER SHIFT, L, movewindow, r"
      ] ++ lib.flatten (map (n: [
        "SUPER, ${toString n}, workspace, ${toString n}"
        "SUPER SHIFT, ${toString n}, movetoworkspace, ${toString n}"
      ]) [1 2 3 4 5 6 7 8 9] ++ [
        "SUPER, 0, workspace, 10"
        "SUPER SHIFT, 0, movetoworkspace, 10"
      ]);
    };
  };
}
```

### Extra components the GNOME settings implied (→ `home.packages` / `programs.*`)

- screenshot: `grimblast` + `slurp` + `wl-clipboard`
- lock: `loginctl lock-session` (`systemd`); optional `hyprlock`
- wallpaper: `hyprpaper` (or `swaybg`) — `st` swaps carnation↔zima-blue (Phase 4)
- night-light 19→6: `services.gammastep` user unit (HM)
- lid-close nothing: NixOS `services.logind.lidSwitch = "ignore"` (+ `lidSwitchExternalPower`/`lidSwitchDock`)
- clock 12h + show-title: `waybar`
- default browser brave: `xdg.mimeApps` (HM)

**Acceptance:** graphical Hyprland session; every Super keybind matches the
GNOME set 1:1; `caps:none`, gaps 2, animations off, 10 persistent workspaces;
wallpaper set; `Super+Shift+S` screenshots to clipboard; `Super+Shift+colon`
locks the session.

## Phase 3 — Dotfiles via Home Manager
Port each existing config dir verbatim where possible (Home Manager can
symlink/source the files rather than rewrite them). **Both dotfiles and user
services are managed by Home Manager** — `programs.*` for app config, and
`services.*` / `systemd.user` units for syncthing (and any user-scoped
daemons). Nothing writes to `~/.config` outside Home Manager; no manual
symlinks survive `home-manager switch`.

| Existing                        | Home Manager module       | Notes |
|---------------------------------|---------------------------|-------|
| `nvim/` (init.lua + lua/)       | `programs.neovim` + xdg    | keep lua as-is; plugins via `lazy.nvim` |
| `kitty/` (+ theme switch)       | `programs.kitty`           | theme.conf is the switch target |
| `scripts/switch_theme.sh`       | `home/packages/theme-switch.nix` → `st` app | see Phase 4 |
| `btop/`                         | `programs.btop`            | GPU needs `nvidia-ml-py` equivalent — use `nvtop` instead |
| `refree/config.yaml`            | `xdg.configFile`           | symlink as before |
| `omp/skills` → `~/.omp/agent/skills` | `xdg.dataFile`/symlink | |

Packages the host *does* install (system or home): `kitty zellij neovim
btop bat dust ripgrep eza bacon brave keepassxc krita xournalpp calibre
heif thumbnailer chrony net-tools syncthing nvtop git`. These are runtime
apps, not dev toolchains. Two custom apps ship as Home Manager packages:
`st` (theme switch, Phase 4) and `db` (distrobox launcher, Phase 5b).

**Removed from host** (vs. current Ubuntu scripts): `mise`, `rustup`,
`go`, `python@3.10`, `uv`, `node@lts`, `cargo`-installed CLIs,
`nvidia-cuda-toolkit`, `cuda-toolkit-12-6`, `pip torch`, `ros-humble-*`,
`ros-dev-tools`, `docker-desktop`, `virtualbox`, `steam`/`discord` snap
(move to optional profile if wanted). `setup_hosts.sh` jetson entry stays
(hosts file via `networking.hosts`).

**Acceptance:** `home-manager switch` produces a desktop indistinguishable
from the old one for everyday editing/terminal use; `st` theme switch works.

## Phase 4 — Theme switching as a Nix application

`setup_gnome.sh` and the gsettings half of `switch_theme.sh` are GNOME-only;
they go away. The switcher is no longer a loose `~/.local/bin/st` script —
it is a real package built by Nix and installed via Home Manager, so `st`
ends up on `$PATH` with its runtime deps (`coreutils`, `hyprland`'s
`hyprctl`, `kitty`, `procps` for signals) pinned by the derivation.

`home/packages/theme-switch.nix`:
```nix
# home/packages/theme-switch.nix
{ lib, stdenv, writeShellApplication, coreutils, hyprland, kitty, procps
, light ? ./theme-files/light, dark ? ./theme-files/dark }:
writeShellApplication {
  name = "st";
  runtimeInputs = [ coreutils hyprland kitty procps ];
  text = builtins.readFile ./st.sh;        # the toggle logic, ported below
  # ship the light/dark theme files as package resources so `st` copies
  # from $out/share/theme/<theme>/ rather than the mutable repo checkout
  passthru.resources = { inherit light dark; };
}
```

The `st.sh` logic (ported from `scripts/switch_theme.sh`, gsettings dropped):
1. Toggle `~/.config/.theme` (0=dark, 1=light) — matches existing convention.
2. Copy `$out/share/theme/<light|dark>/kitty.conf`   → `~/.config/kitty/theme.conf`,
   `…/btop.theme` → `~/.config/btop/themes/theme.theme`,
   `…/nvim.lua`   → `~/code/configs-nix/dotfiles/nvim/lua/theme.lua` (so nvim
   reads the change on next startup / `:source`).
3. `hyprctl reload` for Hyprland; reload kitty's theme in running instances
   via `kitty +kitten themes` / `SIGUSR1`; nvim picks up `theme.lua` on read.

The per-app `light_theme.*`/`dark_theme.*` files already exist in
`dotfiles/kitty/`, `dotfiles/btop/themes/`, `dotfiles/nvim/lua/` — moved into
the package's `theme-files/{light,dark}/` resource tree. No content change,
just the driver.

Installed via `home.packages = [ (pkgs.callPackage ./packages/theme-switch.nix {}) ];`.

**Acceptance:** `which st` → a store path; running `st` flips Hyprland + kitty
+ btop + nvim consistently, and `home-manager switch` reinstalls it.

## Phase 5 — Shell config port

`shell.nix` (`programs.bash`) ports `setup_bashrc_common.sh` +
`setup_bashrc_desktop.sh`:
- Aliases: `cat→bat`, `top/htop→btop`, `ls→eza`, `du→dust`, `vim/vi→nvim`,
  `z/tmux→zellij`, `scp→rsync`, `start→xdg-open`, `cd*`, `qgc`, etc.
- Functions: `venvup`, `diary`, `rdid` (ROS_DOMAIN_ID setter — unchanged).
- SSH aliases (`e1`, `e1j`, `e3`, `tur`, `rpiasus1local`, …) — unchanged,
  these reach remote robots from the desktop.
- `ROS_LOCALHOST_ONLY=0`, `RMW_IMPLEMENTATION=rmw_cyclonedds_cpp` — move
  into the containers' shell init (Phase 6), **not** the host shell, since
  ROS is no longer on the host. Host shell keeps `rdid` only as a
  convenience that the container honors via a shared env file.

`setup_git.sh` / `setup_user.sh` become Home Manager state (`programs.git`
+ the identity values below), not destructive `~/.bashrc` appends.

### Identity — single source of truth
The four identity values live once, as a `let` binding at the top of
`flake.nix`, and are passed into every NixOS / Home Manager module via
`specialArgs`. There is no `identity.nix` module — `flake.nix` is the only
place these strings are written.

```nix
# flake.nix
{
  inputs = { ... };
  outputs = { self, nixpkgs, home-manager, ... }:
  let
    identity = {
      user     = "azada";
      fullName = "Aditya Azad";
      email    = "adityaazad121@gmail.com";
      host     = "legion-7i";
    };
    mkHost = modules: nixpkgs.lib.nixosSystem {
      inherit modules;
      specialArgs = { inherit identity; };   # inject into every module
    };
  in {
    nixosConfigurations.${identity.host} = mkHost [ ./hosts/legion-7i/default.nix ];
    # homeConfigurations.${identity.user} = home-manager ... specialArgs identity;
  };
}
```

Consumers read `identity` from module args (not `config.identity`, since it
is not an option):
- `networking.hostName = identity.host;` → `legion-7i`
- `users.users.${identity.user}` → system user `azada`, with
  `description = identity.fullName`
- Home Manager `programs.git` →
  `userName = identity.fullName; userEmail = identity.email;`
- Shell init exports the same four as env vars (`USER_NAME`,
  `USER_FULL_NAME`, `USER_EMAIL_ADDRESS`, `HOST_NAME`) so the legacy
  `rdid`/aliases that read them keep working
- `users.users.${identity.user}.extraGroups = [ "docker" ]` (Phase 1)

Remote SSH aliases (`azada@rpi-app-server-us-1.local`) and GitHub slugs
(`aditya-azad/refree`, `aditya-azad/obelisk`) are *remote* / *upstream*
identities, not the local committer identity — they stay literal and are
NOT sourced from `identity`.

## Phase 5b — `db`: distrobox launcher app

`db` is a Home Manager package (`home/packages/db.nix`) that lists and
enters distrobox containers. Like `st` it is a real Nix derivation
(`writeShellApplication`) with `distrobox` and `docker` pinned as runtime
deps; the container registry is injected at build time from the flake so
the script never hardcodes image names.

```nix
# home/packages/db.nix
{ lib, writeShellApplication, distrobox, docker, jq }:
{ boxes ? {}   # attrset: name -> image, built in flake.nix from containers/*
}:
writeShellApplication {
  name = "db";
  runtimeInputs = [ distrobox docker jq ];
  # bake the box registry in as a bash assoc array
  text = ''
    declare -A BOXES=(${
      lib.concatStringsSep " "
        (lib.mapAttrsToList (n: img: ''["${n}"]="${img}"'') boxes)
    })
    ${builtins.readFile ./db.sh}
  '';
}
```

`db.sh` behavior:
- **`db`** (no args) — print every box in the registry with its created
  status (`distrobox list | jq -r .name`) and a `*` marker for the active
  one. Example:
  ```
  ros2-humble   [created]   localhost/ros2-humble:latest
  ros2-kilted   [—]         localhost/ros2-kilted:latest
  ```
- **`db <name>`** — validate `<name>` is in the registry; if the container
  doesn't exist, `distrobox create --name <name> --image <image> --nvidia`
  first (using the `distrobox.ini` from `containers/<name>/` for
  mounts/env), then `distrobox enter <name>`.
- Unknown name → error + list available boxes; `db -h` → usage.

The registry is generated in `flake.nix`:
```nix
boxes = lib.mapAttrs' (n: v: lib.nameValuePair n v.image)
  (import ./containers/registry.nix);   # { ros2-humble = {...}; ros2-kilted = {...}; }
home.packages = [ (pkgs.callPackage ./home/packages/db.nix { inherit boxes; }) ];
```
Adding a third container later = drop a new `containers/<name>/` dir and
re-evaluate the flake; `db` picks it up with no script edit.

**Acceptance:** `db` lists both ROS 2 boxes; `db ros2-humble` creates (if
absent) and enters the container with GPU passthrough; `db nope` errors
and lists valid names.

## Phase 6 — ROS 2 Distrobox containers

Two containers, identical structure, different base + distro. Each is a
built OCI image (Containerfile) plus a `distrobox.ini` describing mounts/env,
plus an `init.sh` run once after `distrobox create`.

### ros2-humble (Ubuntu 22.04 base)
`Containerfile`:
```dockerfile
FROM ubuntu:22.04
# 1. ROS 2 Humble desktop + ros-dev-tools (apt, ros2-apt-source)
# 2. PX4 1.15 (build deps + clone PX4-Autopilot v1.15, checkout)
# 3. CUDA toolkit 12.6 (nvidia local repo for ubuntu2204)
# 4. Python + pip + PyTorch cu126 (torch/torchvision from pytorch whl index)
# 5. udev/rules for flight controllers, Cyclone DDS config defaults
```
`distrobox.ini`:
```ini
[ros2-humble]
image = localhost/ros2-humble:latest
nvidia = true                       # GPU passthrough (host driver)
home = ...                          # shared ~/code, ~/database mounts
init = false
additional_packages = ""
volume = /dev:/dev :/run/udev:/run/udev
entry = /bin/bash
# Host network (default) so DDS multicast works across containers/robots
```

### ros2-kilted (Ubuntu 24.04 base)
Same shape. Kilted targets Ubuntu Noble (24.04); PX4 1.15 builds on Noble;
pick a CUDA build matching the PyTorch wheel for Noble (cu124/cu126).
```dockerfile
FROM ubuntu:24.04
# ROS 2 Kilted (apt), PX4 1.15, CUDA (Noble repo), PyTorch cuXXX
```

### Shared concerns
- **NVIDIA:** `--nvidia` / `nvidia=true` mounts the host driver libs into
  the container; the container's own CUDA toolkit provides the rest. Host
  driver version ≥ container CUDA's required minimum.
- **DDS networking:** Distrobox uses host networking by default →
  `ROS_DOMAIN_ID`/Cyclone DDS multicast reach real robots on the LAN. Each
  container defaults to a distinct `ROS_DOMAIN_ID` to avoid cross-talk;
  `rdid` inside the container adjusts it live.
- **PX4 SITL/HITL:** PX4 built inside each container; `PX4_PATH` alias set
  per-container. HITL needs the USB flight controller passed through
  (`--device /dev/ttyACM0` via `distrobox.ini` `volume`/`--device`).
- **Project toolchains:** inside a container, each project uses its own
  `uv` venv / `pyproject.toml` to pin Python + PyTorch + CUDA patch. The
  container provides a baseline; the project refines it. No global
  language install on the host.

**Acceptance:** `db ros2-humble` enters the box → `ros2 topic list` works,
PX4 SITL launches, `python -c "import torch; torch.cuda.is_available()"`
is True. Same for `db ros2-kilted`. (Bare `distrobox enter` also works; `db`
is the documented entry point.)

## Phase 7 — Wrap-up

- Delete `scripts/install-ubuntu-22-desktop.sh` and the bash scripts once
  their content is fully ported into Nix modules (the scripts are the
  *source of truth* to port from; remove only after each line is accounted
  for).
- Keep `scripts/switch_theme.sh` logic only as long as needed; replaced by
  `theme.nix`.
- Update `README.md` to reflect NixOS + flake workflow
  (`nixos-rebuild switch --flake .#legion-7i`, `home-manager switch`, distrobox
  create commands).
- Optional profiles (toggle via flake outputs): gaming (steam, discord),
  virtualization (keep VMs in containers instead of VirtualBox on host).

## Open decisions

1. **Stable vs unstable NixOS** for the host channel — unstable tracks
   Hyprland/NVIDIA better; recommended unstable.
2. **CUDA/PyTorch versions per container** — pin now (humble→cu126, kilted
   →cu126/cu124) or let projects override inside their venv.
3. **Project toolchain manager** inside containers — `uv` (Python) +
   per-project CUDA, vs Devbox/Nix shell inside the container. Recommend
   `uv` for Python/CUDA; plain apt for non-Python.
4. **Distrobox runtime** — docker only (Phase 1 sets
  `container_manager="docker"` via `/etc/distrobox/distrobox.conf`); no
  podman on the host. Override a single box in its `distrobox.ini` if a
  rootless/daemonless runtime is ever needed.

## Order of execution

0a (author on dev box) → 1 → 2 → 3 (overlap w/ 2) → 4 → 5 → 5b → 6 → 0b
(apply on `legion-7i`) → 7.
`0a` and Phases 1–6 are all done on the dev box — building, not switching.
`0b` is the only step that touches the target, once the config is ready.
Phase 6 (containers) + Phase 5b (`db`) can start as soon as Phase 1
(NVIDIA + container runtime) is done; `db` needs the container registry
from Phase 6's `containers/*` dirs to be meaningful.
