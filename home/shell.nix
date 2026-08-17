# home/shell.nix
# programs.bash port of scripts/setup_bashrc_common.sh +
# scripts/setup_bashrc_desktop.sh. ROS_LOCALHOST_ONLY / RMW_IMPLEMENTATION and
# the colcon/ROS aliases move into the CONTAINERS (Phase 6), not the host shell.
# `rdid` stays on the host as a convenience the container honors via env.
{ identity, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      # system shortcuts
      start = "xdg-open";
      brc   = "nvim ~/.bashrc";
      # directories
      cdc = "cd ~/code";
      cdd = "cd ~/Downloads";
      cdw = "cd ~/database/workspace";
      # utils
      cat  = "bat";
      top  = "btop";
      htop = "btop";
      ls   = "eza";
      du   = "dust";
      z    = "zellij";
      tmux = "zellij";
      scp  = "rsync -avP";
      # editor
      vim = "nvim";
      vi  = "nvim";
      # documents
      todo  = "nvim ~/database/workspace/inbox.md";
      ideas = "nvim ~/database/workspace/ideas.md";
      # robotics (host-side: ground control only; ROS build aliases are per-container)
      qgc = "QGroundControl-x86_64.AppImage";
      # chrony (host service)
      chrons = "chronyc sources";
      chronr = "sudo systemctl restart chronyd";
      chronc = "sudo nvim /etc/chrony/chrony.conf";
      # ssh aliases — unchanged, reach remote robots from the desktop
      e1  = "ssh -Y eagle1@eagle1";
      e1j = "ssh -Y eagle1@jetson";
      e3  = "ssh -Y eagle3@eagle3";
      e3j = "ssh -Y eagle3@jetson";
      e7  = "ssh -Y eagle7@eagle7";
      e7j = "ssh -Y eagle7@jetson";
      eaj = "ssh -Y eaglea@jetson";
      tur = "ssh -Y aazad@turing.wpi.edu";
      rpiasus1local = "ssh -Y azada@rpi-app-server-us-1.local";
    };

    # identity as env vars so legacy `rdid`/aliases that read them keep working
    sessionVariables = {
      EDITOR             = "nvim";
      USER_NAME          = identity.user;
      USER_FULL_NAME     = identity.fullName;
      USER_EMAIL_ADDRESS = identity.email;
      HOST_NAME          = identity.host;
    };

    initExtra = ''
      # vi-mode (set -o vi) + Ctrl-L clears the screen
      set -o vi
      bind -m vi-command 'Control-l: clear-screen'
      bind -m vi-insert  'Control-l: clear-screen'

      # ── venvup: walk up to the nearest .venv/venv and activate it ─────────────
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

      # ── diary: open today's note in nvim ──────────────────────────────────────
      diary() {
        local notes_dir="$HOME/database/workspace/diary"
        local today file
        today=$(date +"%Y-%m-%d")
        file="$notes_dir/$today.md"
        [ -f "$file" ] || touch "$file"
        nvim "$file"
      }

      # ── rdid: set ROS_DOMAIN_ID in the current shell and persist to ~/.bashrc ──
      # Usage: rdid 23
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

      # prompt
      PS1='\[\e[38;5;28m\]\u@\h:\w\[\e[0m\]$ '
    '';
  };
}
