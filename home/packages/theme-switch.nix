# home/packages/theme-switch.nix
# `st` — theme switcher as a real Nix derivation (Phase 4). Replaces the loose
# scripts/switch_theme.sh. gsettings half is dropped (Hyprland has no gsettings).
# Ships light/dark theme files as package resources so `st` copies from the
# store, not the mutable repo checkout.
#
# Implementation: writeShellApplication wraps a copy of st.sh with the runtime
# inputs on PATH. We first run `substituteAll` over st.sh to bake the absolute
# store paths of the theme-files/{light,dark} dirs into @lightDir@/@darkDir@,
# then hand the result to writeShellApplication.
{ lib, writeShellApplication, substituteAll
, coreutils, hyprland, kitty, procps
, light ? ./theme-files/light, dark ? ./theme-files/dark }:

let
  stSh = substituteAll {
    name = "st.sh";
    src = ./st.sh;
    # substituteAll maps attr KEYS to @KEY@ placeholders in the file.
    lightDir = light;
    darkDir  = dark;
  };
in
writeShellApplication {
  name = "st";
  runtimeInputs = [ coreutils hyprland kitty procps ];

  # Resource tree baked into the derivation, exposed for inspection/consumers.
  passthru.resources = { inherit light dark; };

  text = builtins.readFile stSh;
}
