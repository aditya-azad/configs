# home/programs/nvim.nix
# Neovim with the repo's init.lua + lua/ kept verbatim. Plugins are managed by
# lazy.nvim inside the config (PLAN.md Phase 3 table) — we don't enumerate them
# in Nix. `st` rewrites dotfiles/nvim/lua/theme.lua in place.
{ pkgs, config, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # lazy.nvim bootstraps its own plugin tree at runtime; we only ship the
    # runtime deps that init.lua assumes (a TeX/LSP toolchain would belong in
    # containers, not here — host installs no dev toolchains).
    extraPackages = with pkgs; [
      # treesitter compilers + a C toolchain are NOT on the host (principle #1).
      # Add only leaf runtimes nvim itself shells out to:
      ripgrep   # telescope / grep backend
      fd        # telescope file backend
    ];
  };

  # ~/.config/nvim -> repo nvim/ (out-of-store so lazy.nvim can write lockfiles)
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/code/configs-nix/dotfiles/nvim";
    recursive = true;
  };
}
