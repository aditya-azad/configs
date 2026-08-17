# home/hyprland.nix
# Hyprland user config. Every gsettings entry from scripts/setup_gnome.sh is
# reproduced 1:1 (PLAN.md Phase 2 table). NVIDIA env lives here, NOT in nvidia.nix.
{ pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # NVIDIA env
      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];

      # caps:none, keyboard delay 150
      input = {
        xkb_options = "caps:none";
        repeat_delay = 150;
      };

      # popshell gap-inner 2 / gap-outer 2, active-hint border-radius 0
      general   = { gaps_in = 2; gaps_out = 2; border_size = 2; };
      decoration = { rounding = 0; };

      # enable-animations false
      animations = { enabled = false; };

      # 10 persistent workspaces (num-workspaces 10, dynamic-workspaces false)
      workspace = map toString (lib.range 1 10);

      exec-once = [ "waybar" ];

      bind = [
        "SUPER, Return, exec, kitty"                       # default terminal kitty
        "SUPER, B, exec, brave"                            # www Super+b
        "SUPER, E, exec, nautilus"                         # home Super+e
        "SUPER, F, fullscreen, 1"                          # toggle-maximized Super+f
        "SUPER SHIFT, Q, killactive,"                       # close Super+Shift+Q
        "SUPER SHIFT, S, exec, grimblast save area - | wl-copy"  # screenshot
        "SUPER SHIFT, colon, exec, loginctl lock-session"  # screensaver
        "SUPER CTRL ALT, Q, exec, systemctl poweroff"       # custom shutdown
        "SUPER CTRL ALT, R, exec, systemctl reboot"         # custom restart
        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, J, movewindow, d"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, L, movewindow, r"
      ] ++ lib.flatten (map (n: [
        "SUPER, ${toString n}, workspace, ${toString n}"
        "SUPER SHIFT, ${toString n}, movetoworkspace, ${toString n}"
      ]) [ 1 2 3 4 5 6 7 8 9 ]) ++ [
        "SUPER, 0, workspace, 10"
        "SUPER SHIFT, 0, movetoworkspace, 10"
      ];
    };
  };

  # ── hyprpaper as a restartable user service (so `st` can swap the wallpaper
  #    and restart it). `st` owns ~/.config/hypr/hyprpaper.conf (mutable); we
  #    seed a default dark wallpaper if the file is absent on first activation.
  systemd.user.services.hyprpaper = {
    Unit.Description = "Hyprpaper wallpaper daemon";
    Service = {
      ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "default.target" ];
  };

  home.activation.seedHyprpaperConf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "$HOME/.config/hypr/hyprpaper.conf" ]; then
      mkdir -p "$HOME/.config/hypr"
      wp="$HOME/code/configs-nix/dotfiles/wallpapers/zima-blue.png"
      {
        echo "preload = $wp"
        echo "wallpaper = ,$wp"
        echo "splash = false"
      } > "$HOME/.config/hypr/hyprpaper.conf"
    fi
  '';
}
