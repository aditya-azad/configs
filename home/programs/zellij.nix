# home/programs/zellij.nix
# zellij config kept verbatim in dotfiles/zellij/config.kdl; sourced out-of-store.
{ config, ... }:

{
  programs.zellij.enable = true;

  xdg.configFile."zellij" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/code/configs-nix/dotfiles/zellij";
    recursive = true;
  };
}
