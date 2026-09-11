{ config, ... }:
let
  theme = config.alienix.theme.active;
  waybar = theme.style.waybar theme;
in
{
  programs.waybar.settings.mainBar.clock = {
    # Both formats carry Pango markup, so they live with the rest of the
    # presentation rather than here -- the meridiem and the date are coloured
    # out of the palette, which this file has no business knowing.
    format = waybar.clockFormat;
    format-alt = waybar.clockFormatAlt;
    tooltip-format = "<tt><small>{calendar}</small></tt>";
    calendar = {
      mode = "year";
      mode-mon-col = 3;
      weeks-pos = "right";
      on-scroll = 1;
      format = waybar.calendarFormat;
    };
    actions = {
      on-click-right = "mode";
      on-scroll-up = "tz_up";
      on-scroll-down = "tz_down";
    };
  };
}
