{ lib, config, pkgs, username, ... }:

{
  # timezone
  time.timeZone = "America/New_York";

  # internationalization
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # users
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" ];
  };
  nix.settings.trusted-users = [username];

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # system packages
  environment.systemPackages = with pkgs; [
    neovim
    brave
    git
    wget
    curl
    zip
    unzip
    ripgrep
    net-tools
    nvtop
    zellij
    kitty
    btop
    bat
    dust
    eza
    bacon
    keepassxc
    krita
    xournalpp
    calibre
    nautilus
    libheif
  ];

  # flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # gc
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };
  nix.optimise.automatic = true;

  # TODO: temp to copy between hosts
  services.openssh.enable = true;

  # fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.fira-code
    ];
    enableDefaultPackages = false;
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["FiraCode Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  # chrony
  services.chrony.enable = true;

  # hosts file
  networking.hosts."192.168.55.1" = [ "usb" ];

  # dconf
  programs.dconf.enable = true;
}
