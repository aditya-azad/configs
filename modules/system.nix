# modules/system.nix
# Locale, time, the single user, fonts, nix settings, logind lid handling, and
# the system-level Hyprland enable. No languages/compilers/dev libraries here —
# the host is thin (Design principle #1).
{ identity, pkgs, lib, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  # ── locale / time ─────────────────────────────────────────────────────────
  time.timeZone = "America/New_York"; # adjust to your locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "en_US.UTF-8/UTF-8" ];

  # ── networking: hosts file (was scripts/setup_hosts.sh) ────────────────────
  networking.hosts."192.168.55.1" = [ "jetson" ];

  # ── the user ───────────────────────────────────────────────────────────────
  users.users.${identity.user} = {
    isNormalUser = true;
    description = identity.fullName;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };

  # ── fonts (was scripts/install_fonts.sh — FiraCode Nerd Font) ─────────────
  fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }) ];

  # ── Hyprland: system-level enable (Phase 2). User config is home/hyprland.nix ──
  programs.hyprland.enable = true;

  # ── lid-close nothing (GNOME `lid-close-*-action nothing`) ─────────────────
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchExternalPower = "ignore";
    lidSwitchDock = "ignore";
  };

  # ── chrony (host time sync; aliases `chrons`/`chronr`/`chronc` in shell.nix) ──
  services.chrony.enable = true;

  # ── system packages: admin/network only. Everything user-facing is Home Manager ──
  environment.systemPackages = with pkgs; [
    git
    net-tools
    nvtop
  ];

  # This value does NOT affect NixOS upgrades; set it to the first NixOS release
  # installed on the host.
  system.stateVersion = "24.11";
}
