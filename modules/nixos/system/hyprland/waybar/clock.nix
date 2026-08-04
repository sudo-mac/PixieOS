{ config, ... }:
let
  colors = config.lib.stylix.colors;
in
{
  programs.waybar = {
    settings.mainBar.clock = {
      format = "{:%I:%M %p}";
      format-alt = "{:%A, %B %d, %Y (%R)}";
      tooltip-format = "<tt><small>{calendar}</small></tt>";
      calendar = {
        mode = "year";
        mode-mon-col = 3;
        weeks-pos = "right";
        on-scroll = 1;
        format = {
          months = "<span color='#${colors.base0D}'><b>{}</b></span>";
          days = "<span color='#${colors.base05}'><b>{}</b></span>";
          weeks = "<span color='#${colors.base0B}'><b>W{}</b></span>";
          weekdays = "<span color='#${colors.base0A}'><b>{}</b></span>";
          today = "<span color='#${colors.base08}'><b><u>{}</u></b></span>";
        };
      };
      actions = {
        on-click-right = "mode";
        on-scroll-up = "tz_up";
        on-scroll-down = "tz_down";
      };
    };
    style = ''
      #clock {
          font-weight:600;
      }
    '';
  };
}
