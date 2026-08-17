# home/programs/git.nix
# Replaces scripts/setup_git.sh — Home Manager state, not destructive
# ~/.bashrc appends or interactive ssh-keygen. Identity from `identity` (Phase 5).
{ identity, ... }:

{
  programs.git = {
    enable = true;
    userName  = identity.fullName;
    userEmail = identity.email;
    aliases = {
      # keep the repo's existing convention; add more as needed
      st  = "status";
      co  = "checkout";
      br  = "branch";
      ci  = "commit";
      lg  = "log --graph --oneline --decorate --all";
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
}
