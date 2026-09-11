{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  theme = config.alienix.theme.active;
  inherit (theme.tokens) layout;
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
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "${layout.bar.position}";

          # An island bar is a transparent strip with three filled groups sitting
          # in it, so it has to be inset from the screen edge; a continuous bar
          # spans the full width and sits flush.
          margin-top = if layout.bar.position == "top" then layout.bar.margin else 0;
          margin-bottom = if layout.bar.position == "bottom" then layout.bar.margin else 0;
          margin-left = layout.bar.margin;
          margin-right = layout.bar.margin;

          modules-left = [ "hyprland/workspaces" "hyprland/window" ];

          modules-center = [ "clock" "mpris" "custom/media-popup" ];

          modules-right = [ "cpu" "network" "pulseaudio" "battery" "tray" "custom/power" ];

          # A music glyph, not an empty string. The format was "" -- the module
          # drew nothing at all while still taking its padding, so the control
          # was invisible and unclickable-looking and the centre island carried
          # a slug of dead navy next to the clock.
          "custom/media-popup" = {
            format = "󰝚";
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

    # The colour and font definitions are wanted; the rest of stylix's waybar
    # stylesheet is not. Its `.modules-* #workspaces button` rules carry a higher
    # specificity than anything a theme can write against `#workspaces button`,
    # so with addCss on it wins the border-bottom property outright.
    stylix.targets.waybar = {
      enable = true;
      addCss = false;
    };
  };
}
