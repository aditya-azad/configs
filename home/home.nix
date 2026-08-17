# home/home.nix
# Home Manager entry point. Imports every home module and owns the user-facing
# package set. `st` (theme switch) and `db` (distrobox launcher) ship as real
# Nix derivations installed here.
{ identity, boxes, pkgs, lib, config, ... }:

{
  imports = [
    ./shell.nix
    ./hyprland.nix
    ./programs/kitty.nix
    ./programs/zellij.nix
    ./programs/nvim.nix
    ./programs/btop.nix
    ./programs/git.nix
    ./programs/refree.nix
    ./services/syncthing.nix
  ];

  home = {
    username = identity.user;
    homeDirectory = "/home/${identity.user}";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  # ── runtime apps (no dev toolchains — those live in containers) ─────────────
  home.packages = with pkgs; [
    # terminal / editor
    kitty zellij neovim btop nvtop
    bat dust ripgrep eza bacon
    # desktop apps
    brave keepassxc krita xournalpp calibre nautilus
    # Wayland helpers (screenshots, clipboard, lock, wallpaper, night-light, bar)
    grimblast slurp wl-clipboard hyprlock hyprpaper gammastep waybar
    # heif image support (was `heif-gdk-pixbuf`/`heif-thumbnailer` on Ubuntu)
    libheif
  ] ++ [
    # custom apps (Phase 4 + Phase 5b)
    (pkgs.callPackage ./packages/theme-switch.nix { })
    (pkgs.callPackage ./packages/db.nix { inherit boxes; })
  ];

  # ── default browser: brave (GNOME `default-web-browser brave-browser`) ───────
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html"             = "brave-browser.desktop";
      "x-scheme-handler/http"   = "brave-browser.desktop";
      "x-scheme-handler/https"  = "brave-browser.desktop";
      "x-scheme-handler/about"  = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
    };
  };

  # ── night-light (GNOME night-light 19→6). gammastep derives day/night from
  #    latitude/longitude; the fixed 19→6 window is approximated by location.
  #    Worcester, MA (WPI) — adjust to your locale.
  services.gammastep = {
    enable = true;
    latitude  = "42.27";
    longitude = "-71.81";
    temperature = { day = 6500; night = 3500; };
  };

  # ── omp skills: ~/.omp/agent/skills -> repo (was setup_symlinks_common.sh) ──
  #    Out-of-store symlink so the live repo checkout stays editable.
  home.file.".omp/agent/skills".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/code/configs-nix/omp/skills";
}
