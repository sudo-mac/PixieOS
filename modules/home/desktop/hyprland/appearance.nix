{
  config,
  pkgs,
  lib,
  ...
}: let
  colors = config.lib.stylix.colors;
in {
  wayland.windowManager.hyprland.settings = {
    general = {
      border_size = 3;
      gaps_in = 5;
      gaps_out = 15;
      layout = "dwindle";
      resize_on_border = true;
    };

    decoration = {
      rounding = 10;
      active_opacity = 0.75;
      inactive_opacity = 0.8;
      fullscreen_opacity = 100;

      blur = {
        enabled = true;
        xray = true;
        special = false;
        new_optimizations = true;
        size = 14;
        passes = 4;
        brightness = 1;
        noise = 1.0e-2;
        contrast = 1;
        popups = true;
        popups_ignorealpha = 0.6;
        ignore_opacity = false;
      };
    };
    layerrule = [
      "match:namespace waybar, blur on"
    ];
  };
  stylix.targets.hyprland.enable = true;
}
