{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    general = {
      border_size = 3;
      gaps_in = 5;
      gaps_out = 15;
      layout = "dwindle";
      resize_on_border = true;
    };

    animations = {
      enabled = "yes";
      bezier = [
        "easeOutQuart, 0.25, 1, 0.5, 1"
        "easeOutBack, 0.34, 1.56, 0.64, 1"
      ];

      animation = [
        "windows, 1, 5, easeOutQuart"
        "windowsOut, 1, 5, easeOutQuart, popin 20%"
        "border, 1, 5, easeOutQuart"
        "borderangle, 1, 30, easeOutQuart, once"
        "fade, 1, 5, easeOutQuart"
        "workspaces, 1, 5, easeOutQuart"
      ];
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
