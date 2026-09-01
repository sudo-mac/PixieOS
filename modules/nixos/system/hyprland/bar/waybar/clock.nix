{ config, ... }:
let
  theme = config.alienix.theme.active;
in
{
  programs.waybar.settings.mainBar.clock = {
    format = "{:%I:%M %p}";
    format-alt = "{:%A, %B %d, %Y (%R)}";
    tooltip-format = "<tt><small>{calendar}</small></tt>";
    calendar = {
      mode = "year";
      mode-mon-col = 3;
      weeks-pos = "right";
      on-scroll = 1;
      format = (theme.style.waybar theme).calendarFormat;
    };
    actions = {
      on-click-right = "mode";
      on-scroll-up = "tz_up";
      on-scroll-down = "tz_down";
    };
  };
}
