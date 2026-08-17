{ username, config, pkgs, ... }:

let
  qgcVersion = "4.4.3";
  qgcAppImage = pkgs.fetchurl {
    name = "QGroundControl-${qgcVersion}.AppImage";
    url = "https://github.com/mavlink/qgroundcontrol/releases/download/v${qgcVersion}/QGroundControl.AppImage";
    hash = "sha256-wmRAbLFC4+66lDAm1sxSRamoCLtvYj1WGVEBHLnEXkM=";
  };
  qgc = pkgs.writeShellApplication {
    name = "qgc";
    runtimeInputs = [ pkgs.appimage-run ];
    text = ''
      exec appimage-run ${qgcAppImage} "$@"
    '';
  };
in
{
  # home
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
  };
  programs.home-manager.enable = true;

  # user packages
  home.packages = [
    qgc
  ];

  # git config
  programs.git = {
    enable = true;
    userName = "Aditya Azad";
    userEmail = "adityaazad121@gmail.com";
  };

  # default terminal
  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "kitty.desktop" ];
  };

  # default browser
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html"                = "brave-browser.desktop";
      "x-scheme-handler/http"    = "brave-browser.desktop";
      "x-scheme-handler/https"   = "brave-browser.desktop";
      "x-scheme-handler/about"   = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
    };
  };

  # default editor
  environment.variables.EDITOR = "nvim";

  # location provider
  services.geoclue2.enable = true;
  location.provider = "geoclue2";

  # nightlight
  services.gammastep = {
    enable = true;
    provider = "geoclue2";
    temperature = {
      day = 6500;
      night = 3500;
    };
  };

  # syncthing
  # TODO: figure out the symlinking
  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      package = pkgs.syncthingtray-minimal;
    };
  };

  # bash config
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      brc   = "nvim ~/.bashrc";
      cdc = "cd ~/code";
      cdd = "cd ~/Downloads";
      cdw = "cd ~/database/workspace";
      cat  = "bat";
      top  = "btop";
      htop = "btop";
      ls   = "eza";
      du   = "dust";
      z    = "zellij";
      tmux = "zellij";
      scp  = "rsync -avP";
      vim = "nvim";
      vi  = "nvim";
      todo  = "nvim ~/database/workspace/inbox.md";
      ideas = "nvim ~/database/workspace/ideas.md";
      chrons = "chronyc sources";
      chronr = "sudo systemctl restart chronyd";
      chronc = "sudo nvim /etc/chrony/chrony.conf";
      e7  = "ssh -Y eagle7@eagle7";
      e7j = "ssh -Y eagle7@jetson";
      tur = "ssh -Y aazad@turing.wpi.edu";
      bizon = "ssh -Y aazad@bizon";
    };
    initExtra = ''
      # vi-mode
      set -o vi

      # ctrl-l clears the screen
      bind -m vi-command 'Control-l: clear-screen'
      bind -m vi-insert  'Control-l: clear-screen'

      # walk up to the nearest .venv/venv and activate it
      venvup() {
        local dir="$PWD"
        local home="''${HOME%/}"
        local name
        while true; do
          for name in .venv venv; do
            if [ -f "$dir/$name/bin/activate" ]; then
              source "$dir/$name/bin/activate"
              echo "Activated: $dir/$name"
              return 0
            fi
          done
          if [ "$dir" = "$home" ] || [ "$dir" = "/" ]; then
            break
          fi
          dir="$(dirname "$dir")"
        done
        echo "No .venv or venv found from $PWD up to $home" >&2
        return 1
      }

      # ── rdid: set ROS_DOMAIN_ID in the current shell and persist to ~/.bashrc ──
      # TODO: find nixos way
      rdid() {
        if [ -z "''${1-}" ]; then
          echo "Usage: rdid <domain_id>" >&2
          return 2
        fi
        case "$1" in
          '''|*[!0-9]*)
            echo "Error: domain_id must be a non-negative integer." >&2
            return 2
            ;;
          *)
            if [ "$1" -gt 232 ] 2>/dev/null; then
              echo "Warning: domain_id > 232 may be unsupported by some ROS 2 setups." >&2
            fi
            ;;
        esac
        local id="$1"
        local bashrc="$HOME/.bashrc"
        local line="export ROS_DOMAIN_ID=''${id}"
        export ROS_DOMAIN_ID="$id"
        if grep -qE "^[[:space:]]*export[[:space:]]+ROS_DOMAIN_ID=[0-9]+" "$bashrc"; then
          sed -i.bak -E "s|^[[:space:]]*export[[:space:]]+ROS_DOMAIN_ID=[0-9]+$|$line|" "$bashrc"
        else
          printf "\n%s\n" "$line" >> "$bashrc"
        fi
        echo "ROS_DOMAIN_ID set to ''${id} (current shell) and persisted in ~/.bashrc"
      }
    '';
  };

  # hosts
  networking.hosts."130.215.183.33" = [ "bizon" ];
}
