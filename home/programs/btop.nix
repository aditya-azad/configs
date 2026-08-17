# home/programs/btop.nix
# btop config kept verbatim in dotfiles/btop. GPU monitoring via nvtop (host
# package, installed in home.nix) instead of the old nvidia-ml-py hack.
{ config, ... }:

{
  programs.btop.enable = true;

  xdg.configFile."btop" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/code/configs-nix/dotfiles/btop";
    recursive = true;
  };
}
