# home/services/syncthing.nix
# systemd user unit + config. Replaces the hand-installed unit from
# install_software_desktop.sh. Syncthing keys/certs are NOT managed by Home
# Manager (they're per-device secrets); they're left as manual symlinks from
# the passwords store, exactly as setup_symlinks_desktop.sh did.
{ pkgs, config, ... }:

{
  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      package = pkgs.syncthingtray-minimal;
    };
  };

  # Seed the syncthing state dir so the key symlinks have a home; the symlinks
  # themselves (cert.pem/key.pem/etc. -> the passwords store) stay manual since
  # they point outside the repo and are device-specific.
  home.activation.ensureSyncthingState = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.local/state/syncthing"
  '';
}
