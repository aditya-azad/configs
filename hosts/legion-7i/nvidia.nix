# hosts/legion-7i/nvidia.nix
# Host owns the *driver* only. CUDA toolkit + PyTorch live in Distrobox
# containers (Phase 6). GPU access for containers flows through
# nvidia-container-toolkit (container-runtime.nix).
{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;                       # 570+ closed, until open kernels match
    package = config.boot.kernelPackages.nvidiaPackages.beta; # or .stable
    powerManagement.enable = true;      # recover from suspend/hibernate
    nvidiaSettings = true;
  };

  boot.kernelParams = [ "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1" ];
}
