# Kimberly, Street Fighter 6. Palette sampled from the official key art in
# ./wallpapers/kimberly.jpg -- every accent below is a colour that actually
# appears in the image, not an approximation of one.
#
# Fonts, cursor, icons, component slots and the presentation layer all come
# from mkTheme's defaults -- see modules/themes/mkTheme.nix.
{ pkgs }:
{
  meta = {
    name = "kimberly";
    description = "Street Fighter 6 Kimberly -- indigo ground, spray-can accents, sticker edges.";
    polarity = "dark";
  };

  palette = {
    base00 = "0b012d"; # the KIMBERLY wordmark; the art's only large dark mass
    base01 = "150a3c";
    base02 = "241553";
    base03 = "45336f";
    base04 = "8d7fb0";
    base05 = "e7dcf4";
    base06 = "f3ecfb";
    base07 = "fcf9ff";

    base08 = "ed5668"; # the dominant coral-rose background
    base09 = "e8500f"; # her puffer jacket; lifted from #e42003, which is too
    #                    dark-blue-starved to read as foreground text
    base0A = "f8e234"; # lemon-yellow splatters
    base0B = "02cec5"; # the turquoise spray cloud
    base0C = "4ad9ea"; # between the turquoise and the sky blue
    base0D = "08a5e4"; # sky-blue splatters, laces, braid tips
    base0E = "ce56af"; # orchid; the spray can and braid tips
    base0F = "fd77b5"; # hot-pink splatters
  };

  wallpaper = ./wallpapers/kimberly.jpg;

  # Sticker/graffiti shape language: hard corners, a chunky flat keyline, and a
  # cast shadow instead of cybergirl's neon glow.
  tokens = {
    radius = {
      pill = 6;
      window = 4;
      card = 8;
      input = 6;
      shape = 8;
    };

    # from == to, so the border is a flat keyline rather than a gradient --
    # the yellow outline you get spraying a stencil.
    border = {
      width = 4;
      angle = 0;
      from = "base0A";
      to = "base0A";
      inactive = "base02";
    };

    alpha = {
      full = 255;
      strong = 235;
      medium = 200;
      card = 225;
      hairline = 180;
    };

    glow = {
      enable = false;
      color = "base0A";
      layers = [ ];
    };

    shadow = {
      enable = true;
      x = 4;
      y = 4;
      color = "base00";
      a = 0.9;
    };

    # This wallpaper is far louder than cybergirl's -- hot pink across the whole
    # field -- so everything sits more opaque or terminal text has to fight it.
    opacity = {
      active = 0.9;
      inactive = 0.93;
      panel = 1.0;
      bar = 0.94;
    };

    blur = {
      enable = true;
      size = 6;
      passes = 2;
      noise = 1.0e-2;
      xray = false;
    };

    gaps = {
      inner = 4;
      outer = 8;
    };

    accent = {
      primary = "base08"; # coral-rose
      secondary = "base09"; # vermilion
      info = "base0C"; # lighter cyan, distinct from base0D used as the edge colour
      ok = "base0B"; # turquoise
      warn = "base0A"; # yellow
      err = "base09";
    };
  };
}
