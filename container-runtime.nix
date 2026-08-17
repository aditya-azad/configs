# modules/container-runtime.nix
# docker + distrobox + nvidia-container-toolkit. The host driver (nvidia.nix)
# plus nvidia-container-toolkit lets `distrobox --nvidia` / `docker run --gpus
# all` reach the GPU with no CUDA toolkit on the host.
{ identity, pkgs, config, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    liveRestore = true;
    storageDriver = "overlay2";
    daemonSettings = {
      data-root = "/var/lib/docker";   # move to a big disk if needed
      features = { buildkit = true; };
    };
  };

  virtualisation.containers.enable = true;

  # GPU passthrough into distrobox/docker containers.
  hardware.nvidia-container-toolkit.enable = true;

  environment.systemPackages = [ pkgs.distrobox pkgs.docker-compose ];

  # azada in docker group so `docker`/distrobox run without sudo.
  users.users.${identity.user}.extraGroups = [ "docker" ];

  # distrobox default runtime = docker (per-box override via distrobox.ini).
  environment.etc."distrobox/distrobox.conf".text = ''
    container_manager="docker"
  '';
}
