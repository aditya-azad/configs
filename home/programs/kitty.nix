# home/programs/kitty.nix
# programs.kitty config. The repo's kitty.conf is kept verbatim and sourced
# via xdg.configFile (Home Manager can symlink the existing dir). theme.conf is
# the live switch target that `st` (Phase 4) rewrites.
{ config, ... }:

{
  programs.kitty.enable = true;

  # Symlink the whole kitty config dir out-of-store so it stays editable and
  # `st` can rewrite theme.conf in place.
  xdg.configFile."kitty" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/code/configs-nix/dotfiles/kitty";
    recursive = true;
  };
}
