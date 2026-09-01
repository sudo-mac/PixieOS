{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  theme = config.alienix.theme.active;
in
{
  imports = [
    ./cpu.nix
    ./tray.nix
    ./battery.nix
    ./clock.nix
    ./pulseaudio.nix
    ./workspaces.nix
    ./network.nix
    ./window.nix
    ./media.nix
  ];

  # Only build the bar when the active theme actually selects waybar for the
  # bar slot. The sibling *.nix files only contribute settings, which are inert
  # while programs.waybar stays disabled.
  config = mkIf (theme.components.bar == "waybar") {
    home.packages = [ pkgs.playerctl ];

    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          blur = true;

          modules-left = [ "hyprland/workspaces" "hyprland/window" ];

          modules-center = [ "clock" "mpris" "custom/media-popup" ];

          modules-right = [ "cpu" "network" "pulseaudio" "battery" "tray" "custom/power" ];

          "custom/media-popup" = {
            format = "";
            tooltip = "Now playing — click to expand";
            on-click = ''rofi -show media-player -modi "media-player:$HOME/.config/rofi/scripts/media-player.sh"'';
          };

          "custom/power" = {
            format = "⏻";
            tooltip = "Power";
            on-click = "wlogout";
          };
        };
      };

      # All presentation lives in the theme.
      style = (theme.style.waybar theme).css;
    };

    stylix.targets.waybar.enable = true;
  };
}
