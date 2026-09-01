# Presentation for notifications: the colour/shape half of dunst's settings.
# Geometry and behaviour stay in the component module.
{ tokens, fonts, c, ... }:
{
  global = {
    highlight = c.hex "base0D";

    corner_radius = tokens.radius.card;
    frame_width = 2;
    frame_color = c.hex "base0D";
    separator_color = "frame";
    separator_height = 2;

    font = "${fonts.ui.name} 11";
    transparency = 8;
  };

  urgency_low = {
    background = c.hex "base00";
    foreground = c.hex "base04";
    frame_color = c.hex tokens.border.inactive;
  };

  urgency_normal = {
    background = c.hex "base00";
    foreground = c.hex "base05";
    frame_color = c.hex "base0D";
  };

  urgency_critical = {
    background = c.hex "base00";
    foreground = c.hex "base07";
    frame_color = c.accentHex "err";
  };
}
