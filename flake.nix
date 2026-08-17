{
  description = "NixOS + Hyprland config for legion-7i (authored on the dev box, applied on the target)";

  inputs = {
    # Unstable tracks Hyprland + NVIDIA better (see PLAN.md, Open decision #1).
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    # ── identity: single source of truth (Phase 5) ──────────────────────────
    # The only place these four strings are written. Every NixOS / Home Manager
    # module reads them from the `identity` arg injected via specialArgs.
    identity = {
      user     = "azada";
      fullName = "Aditya Azad";
      email    = "adityaazad121@gmail.com";
      host     = "legion-7i";
    };

    system = "x86_64-linux"; # legion-7i is Intel i9-12900HX; dev box is same arch

    # Container registry (Phase 5b/6): name -> { image = ...; ... }
    # Flattened to name -> image for the `db` launcher.
    boxes =
      nixpkgs.lib.mapAttrs' (n: v: nixpkgs.lib.nameValuePair n v.image)
        (import ./containers/registry.nix);

    mkHost = extraModules: nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [ home-manager.nixosModules.home-manager
          ./hosts/legion-7i/default.nix
        ] ++ extraModules;
      specialArgs = { inherit identity boxes; };
    };
  in {
    # `nixos-rebuild switch --flake .#legion-7i` on the target builds this.
    nixosConfigurations.${identity.host} = mkHost [ ];
  };
}
