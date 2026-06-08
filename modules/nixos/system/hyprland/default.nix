{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
{
  options = {
    alienix.system.hyprland.enable = mkEnableOption "Enable and configure Hyprland for the system.";
  };

  config = mkIf config.alienix.system.hyprland.enable {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };

    programs = {
      hyprland.enable = true;
      hyprland.xwayland.enable = true;
      hyprlock.enable = true;
    };

    hardware.graphics.enable = true;

    xdg.portal.enable = true;

    home-manager.users.dex.config = {
      wayland.windowManager.hyprland = {
        enable = true;

        extraLuaFiles = {
          "appearance" = {
            content = ./appearance.lua;
            autoLoad = true;
          };

          "monitors" = {
            content = ./monitors.lua;
            autoLoad = true;
          };

          "keybindings" = {
            content = ./keybindings.lua;
            autoLoad = true;
          };
        };
      };

      home.packages = with pkgs; [
        waybar
        dunst
        wlogout
        swaylock
        awww
        networkmanagerapplet
        libnotify
      ];
    };
  };
}
