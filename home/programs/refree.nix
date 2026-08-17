# home/programs/refree.nix
# refree config (was scripts/setup_symlinks_desktop.sh: ~/.refree -> repo refree/).
# The `refree` app itself is installed from its own repo on the target; here we
# only manage the config symlink so nothing writes to ~/.config outside HM.
{ config, ... }:

{
  xdg.configFile."refree" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/code/configs-nix/refree";
    recursive = true;
  };
}
