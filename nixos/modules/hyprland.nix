{ lib, config, pkgs, username, ... }:
{
  home.packages = with pkgs; [
    grimblast
    slurp
    wl-clipboard
    hyprlock
    hyprpaper
    gammastep
    waybar
  ];

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
        "SUPER, T, exec, kitty"
        "SUPER, B, exec, brave"
        "SUPER, E, exec, nautilus"
        "SUPER, F, fullscreen, 1"
        "SUPER SHIFT, Q, killactive,"
        "SUPER SHIFT, S, exec, grimblast save area - | wl-copy"
        "SUPER SHIFT, colon, exec, loginctl lock-session"
        "SUPER CTRL ALT, Q, exec, systemctl poweroff"
        "SUPER CTRL ALT, R, exec, systemctl reboot"
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

  # TODO: find out how to do this better with st, also make st a package if possibel
  # wallpaper
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
