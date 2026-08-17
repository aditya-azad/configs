# home/packages/db.nix
# `db` — distrobox launcher (Phase 5b). Real Nix derivation
# (writeShellApplication) with distrobox + docker + jq pinned as runtime deps.
# The container registry (name -> image) is injected at build time from the
# flake (`boxes`), so the script never hardcodes image names.
{ lib, writeShellApplication, distrobox, docker, jq
, boxes ? {} }:

writeShellApplication {
  name = "db";
  runtimeInputs = [ distrobox docker jq ];

  # Bake the box registry in as a bash associative array literal. Each entry:
  #   ["ros2-humble"]="localhost/ros2-humble:latest"
  text = ''
    declare -A BOXES=(${
      lib.concatStringsSep " "
        (lib.mapAttrsToList (n: img: ''["${n}"]="${img}"'') boxes)
    })
    ${builtins.readFile ./db.sh}
  '';
}
