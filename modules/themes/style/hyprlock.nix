# Presentation for the lock screen: every colour, radius, font and the
# background image. Layout and label text stay in the component module.
{
  tokens,
  fonts,
  wallpaper,
  c,
  ...
}:
let
  inherit (tokens) radius;

  a = slot: byte: "rgba(${c.hexA slot byte})";
  s = slot: "rgb(${c.bare slot})";

  size = mult: builtins.floor (fonts.sizes.desktop * mult + 0.5);
in
{
  # The backdrop has to sit far enough back that near-white clock digits read
  # over it, but the wallpaper is the theme -- at brightness 0.45 under
  # kimberly's 8/3 blur the key art came out as an even brick-red mud with the
  # character no longer visible in it at all. 0.68 with the vibrancy lifted to
  # match keeps the silhouette and the spray-can colours legible while still
  # dropping a good stop below the foreground text.
  background = {
    path = toString wallpaper;
    color = s "base00";
    blur_size = tokens.blur.size;
    blur_passes = tokens.blur.passes;
    noise = tokens.blur.noise;
    contrast = 1.1;
    brightness = 0.68;
    vibrancy = 0.35;
    vibrancy_darkness = 0.25;
  };

  shape = {
    rounding = radius.shape;
    color = a "base00" tokens.alpha.card;
    border_size = 2;
    border_color = "${a tokens.border.from tokens.alpha.hairline} ${a tokens.border.to tokens.alpha.hairline} ${toString tokens.border.angle}deg";
  };

  # The three label sizes are multiples of the theme's declared desktop size
  # rather than fixed points, so a theme that wants larger UI text gets a
  # proportionally larger lock screen instead of a mismatched one.
  clock = {
    font_size = size 12.5;
    # Fixed-width cut on purpose: proportional digits jitter as $TIME ticks.
    font_family = fonts.monospace.name;
    color = s "base06";
    shadow_color = a "base00" tokens.alpha.strong;
  };

  date = {
    font_size = size 2.5;
    font_family = fonts.ui.name;
    color = s "base04";
  };

  greeting = {
    font_size = size 1.67;
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
