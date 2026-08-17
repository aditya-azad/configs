# hosts/legion-7i/hardware-configuration.nix
# ── PLACEHOLDER ──────────────────────────────────────────────────────────────
# This file is machine-specific and GENERATED on the target by
# `nixos-generate-config` (PLAN.md Phase 0b). Replace this whole file with the
# real one from legion-7i (filesystems, boot.initrd, kernel modules) before
# running `nixos-rebuild switch --flake .#legion-7i` there.
#
# The stub below keeps the closure EVALUATING on the dev box (Phase 0a
# acceptance: `nix build .#nixosConfigurations.legion-7i.config.system.build.toplevel`)
# without claiming any real disk layout.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # Dummy root — overwritten by the real generated file on the target.
  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  swapDevices = [ ];

  # The real generated file sets nixpkgs.hostPlatform here too; we set it in
  # the host module instead, so leave this out to avoid a duplicate-default.
}
