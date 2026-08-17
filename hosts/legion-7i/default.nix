# hosts/legion-7i/default.nix
# Host entry point. Imports the generated hardware config, the NVIDIA driver
# module, the system + container-runtime modules, and wires Home Manager in for
# `identity.user`. Authored on the dev box; applied on `legion-7i`.
{ identity, boxes, ... }:

{
  imports = [
    ./hardware-configuration.nix   # generated on the target (0b) — placeholder here
    ./nvidia.nix                   # NVIDIA driver only (no CUDA toolkit on host)
    ../../modules/system.nix       # locale, time, users, fonts, nix, hyprland enable, logind
    ../../modules/container-runtime.nix # docker + distrobox + nvidia-container-toolkit
  ];

  networking.hostName = identity.host; # legion-7i — can't drift from the flake output

  nixpkgs.hostPlatform = "x86_64-linux";

  # Home Manager as a NixOS module. `identity` + `boxes` forwarded so home
  # modules read them the same way system modules do.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit identity boxes; };
    users.${identity.user} = {
      home.username = identity.user;
      home.homeDirectory = "/home/${identity.user}";
      imports = [ ../../home/home.nix ];
    };
  };
}
