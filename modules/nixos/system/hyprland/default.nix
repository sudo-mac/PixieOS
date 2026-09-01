{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  theme = config.alienix.theme.active;
  hypr = theme.style.hyprland theme;
in
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

    home-manager.users.dex = {
      # Every component slot is imported unconditionally -- `imports` cannot
      # live inside mkIf -- and each module gates its own config on the active
      # theme's `components` selection.
      imports = [
        ./launcher/rofi.nix
        ./bar/waybar
        ./lock/hyprlock.nix
        ./notifier/dunst.nix
        ./wallpaper/awww.nix
      ];

      config = {
        wayland.windowManager.hyprland = {
          enable = true;

          extraLuaFiles = {
            "autostart" = {
              content = ./autostart.lua;
              autoLoad = true;
            };

            # Generated from the theme: borders, rounding, blur, opacity, gaps
            # and cursor size all come from its tokens.
            "appearance" = {
              content = pkgs.writeText "appearance.lua" ''
                ${hypr.appearance}
                ${hypr.cursorEnv}
              '';
              autoLoad = true;
            };

            "animations" = {
              content = pkgs.writeText "animations.lua" hypr.animations;
              autoLoad = true;
            };

            "rules" = {
              content = ./rules.lua;
              autoLoad = true;
            };

            "monitors" = {
              content = ./monitors.lua;
              autoLoad = true;
            };

            "input" = {
              content = ./input.lua;
              autoLoad = true;
            };

            "keybindings" = {
              content = ./keybindings.lua;
              autoLoad = true;
            };
          };
        };

        home.packages = with pkgs; [
          wlogout
          networkmanagerapplet
          libnotify
        ];
      };
    };
  };
}
