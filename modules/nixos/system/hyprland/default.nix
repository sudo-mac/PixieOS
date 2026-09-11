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

      # pkgs.hyprland ships hyprland-uwsm.desktop unconditionally, and the
      # greeter lists it alongside the plain session. Without this the entry is
      # a trap: `uwsm start` needs wayland-session-bindpid@.service, which only
      # programs.uwsm.enable installs (via systemd.packages), so selecting it
      # kills the session with systemctl exit 5 and greetd loops back to the
      # greeter. withUWSM turns programs.uwsm.enable on for us.
      hyprland.withUWSM = true;

      hyprlock.enable = true;
    };

    hardware.graphics.enable = true;

    # programs.hyprland supplies xdg-desktop-portal-hyprland, which does not
    # implement org.freedesktop.appearance -- without a gtk portal beside it
    # there is no colour-scheme provider and no themed file chooser, so GTK4
    # and libadwaita apps cannot follow the theme's dark preference.
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.hyprland.default = [
        "hyprland"
        "gtk"
      ];
    };

    # GTK apps read their theme out of dconf; without this the settings.ini and
    # gtk.css stylix generates are written but never picked up.
    programs.dconf.enable = true;

    home-manager.users.dex = {
      # Every component slot is imported unconditionally -- `imports` cannot
      # live inside mkIf -- and each module gates its own config on the active
      # theme's `components` selection.
      imports = [
        ./launcher/rofi.nix
        ./bar/waybar
        ./lock/hyprlock.nix
        ./notifier/dunst.nix
        ./power/wlogout.nix
        ./wallpaper/awww.nix
      ];

      config = {
        wayland.windowManager.hyprland = {
          enable = true;

          # uwsm owns graphical-session.target and the wayland-wm@ unit; leaving
          # home-manager's own systemd integration on makes both try to manage
          # the session target.
          systemd.enable = false;

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
                ${hypr.barLayerRule}
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
          networkmanagerapplet
          libnotify

          # Both are needed by keybindings.lua rather than by any one component:
          # playerctl backs the XF86Audio* binds and wl-clipboard backs the
          # screenshot bind, so neither can live behind a theme.components gate.
          playerctl
          wl-clipboard
        ];
      };
    };
  };
}
