# Presentation for the lock screen: every colour, radius, font and the
# background image. Layout and label text stay in the component module.
{ tokens, fonts, wallpaper, c, ... }:
let
  inherit (tokens) radius;

  a = slot: byte: "rgba(${c.hexA slot byte})";
  s = slot: "rgb(${c.bare slot})";
in
{
  background = {
    path = toString wallpaper;
    color = s "base00";
    blur_size = 6;
    blur_passes = 3;
    noise = 0.02;
    contrast = 1.05;
    brightness = 0.45;
    vibrancy = 0.2;
    vibrancy_darkness = 0.3;
  };

  shape = {
    rounding = radius.shape;
    color = a "base00" tokens.alpha.card;
    border_size = 2;
    border_color = "${a tokens.border.from tokens.alpha.hairline} ${a tokens.border.to tokens.alpha.hairline} ${toString tokens.border.angle}deg";
  };

  clock = {
    # Fixed-width cut on purpose: proportional digits jitter as $TIME ticks.
    font_family = fonts.monospace.name;
    color = s "base06";
    shadow_color = a "base00" tokens.alpha.strong;
  };

  date = {
    font_family = fonts.ui.name;
    color = s "base04";
  };

  greeting = {
    font_family = fonts.ui.name;
    color = s (c.slotOf "info");
  };

  input = {
    rounding = radius.input;
    outline_thickness = tokens.border.width;
    inner_color = a "base01" tokens.alpha.strong;
    outer_color = "${a tokens.border.from tokens.alpha.full} ${a tokens.border.to tokens.alpha.full} ${toString tokens.border.angle}deg";
    check_color = "${a (c.slotOf "ok") tokens.alpha.full} ${a (c.slotOf "info") tokens.alpha.full} 120deg";
    fail_color = "${a (c.slotOf "err") tokens.alpha.full} ${a (c.slotOf "secondary") tokens.alpha.full} 40deg";
    capslock_color = a (c.slotOf "warn") tokens.alpha.full;
    font_color = s "base06";
    font_family = fonts.ui.name;
    shadow_color = a "base00" tokens.alpha.strong;
  };
}
