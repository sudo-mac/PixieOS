# Kimberly, Street Fighter 6. Palette sampled from the official key art in
# ./wallpapers/kimberly.jpg -- every accent below is a colour that actually
# appears in the image, not an approximation of one.
#
# Fonts, cursor, icons and component slots come from mkTheme's defaults; the
# presentation layer does too, except for the bar -- see `style` below.
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

  # The bar is the one surface tokens cannot reshape into a sticker sheet -- the
  # shared style/waybar.nix only knows how to draw a continuous gradient strip of
  # glowing pills -- so this theme brings its own. Everything else still comes
  # from the shared presentation set.
  style = {
    waybar = import ./style/waybar.nix;
  };

  # Sticker/graffiti shape language: flat fills, a bold keyline and a die-cut
  # navy band around it instead of cybergirl's neon glow.
  #
  # The edge is Kimberly's own two colours -- the vermilion of her puffer jacket
  # running into the lemon yellow of the line art that outlines her in the key
  # art -- and not, as it was, the coral-rose of the wallpaper's background. A
  # keyline painted in the colour of the field it sits on is not an edge; the
  # islands dissolved into the art.
  #
  # Flat yellow was the edge before the coral, and was pulled because a 4px band
  # of the palette's loudest colour around every surface is unreadable. That
  # finding still holds and is why the yellow is the far end of the gradient
  # rather than the whole of it: the keyline is mostly vermilion, and the yellow
  # only arrives at the corner it is travelling towards.
  tokens = {

    # Kimberly is a bottom dock of three separate stickers, not a bar: each
    # module group is its own panel with air around it, so the wallpaper reads
    # between them. The launcher is a character-select grid rather than a list,
    # and windows arrive with a hard cut instead of gliding in.
    layout = {
      # Top, not bottom. The stickers themselves work at either edge, but the
      # KIMBERLY wordmark is the bottom-right two-thirds of the wallpaper and
      # its baseline sits at 93% of the image height -- a 62px dock (height +
      # border + lift + margin) lands on the letters. It clears them by 10px on
      # a 1920x1080 output and overlaps by 11px on the 1360x768 one, where the
      # cover-fit crop scales the art down by 0.71. There is no bottom bar
      # height that survives both, so the dock moved to the quiet pink field
      # along the top edge instead.
      bar = {
        position = "top";
        height = 40;
        islands = true;
        margin = 10;
      };

      launcher = {
        mode = "grid";
        columns = 5;
        lines = 4;
        width = 980;
        iconSize = 48;
      };

      # dwindle, not master: `layout("togglesplit")` and `window.pseudo()` (bound
      # to SUPER+J / SUPER+P in keybindings.lua) are dwindle-only dispatchers, so
      # picking master here silently killed two keybinds.
      #
      # "spray", not "snap". `snap` was cybergirl's family with faster numbers
      # in it -- same fades, same horizontal workspace slide, same geometry --
      # which is why this desktop moved like that one in a hurry. `spray` is a
      # family of its own: overshoot on the way in, vertical workspace travel,
      # and panels that press down like a sticker instead of fading up. See the
      # motion block in themes/style/hyprland.nix.
      window = {
        engine = "dwindle";
        motion = "spray";
      };

      # Same edge as the bar -- style/dunst.nix offsets the stack by the bar's
      # own height so the two never collide, which only works if they agree on
      # which edge that is.
      notifier = {
        position = "top-right";
      };
    };

    radius = {
      pill = 8;
      window = 6;
      card = 12;
      input = 8;
      shape = 14;
    };

    # A spray fade rather than a stencil keyline: coral-rose into hot pink at a
    # shallow angle. `c.edge` (themes/lib.nix) reads border.from while glow is
    # off, so this one pair re-colours every shared surface at once.
    #
    # These four numbers have now been changed twice and put back twice, so:
    # they are not the problem and they are not the lever. 4px of flat lemon was
    # too loud; 3px of vermilion-into-lemon was louder still. Both times the
    # reasoning was that a busy wallpaper needs a stroke bold enough to cut
    # through it, and both times what it actually produced was the brightest
    # object on the screen being a rectangle drawn around a window. Separating a
    # surface from the art is the cast shadow's job (see `shadow` below). This
    # stays a thin coral keyline whose only job is marking which window has the
    # keyboard.
    border = {
      width = 2;
      angle = 20;
      from = "base08";
      to = "base0F";
      inactive = "base02";
    };

    alpha = {
      full = 255;
      strong = 214;
      medium = 180;
      card = 235;
      hairline = 150;
    };

    glow = {
      enable = false;
      color = "base08";
      layers = [ ];
    };

    # The thing that actually separates a surface from this wallpaper, and the
    # reason the keyline above could go back to 2px.
    #
    # This was off, on the finding that "neither renderer will draw a hard offset
    # cast shadow". That finding was right and the conclusion drawn from it was
    # wrong: what neither renderer draws is a *hard* one, and a hard one is not
    # what this needs. The art is coral, pink, turquoise and lemon at full
    # saturation, so no keyline colour is reliably distinct from whatever happens
    # to be behind it -- but the art has no deep shadow in it anywhere, so the
    # wordmark's navy is unmistakable over every part of it.
    #
    # Every number here is bounded from above by `gaps.outer`, which is 10. That
    # is the whole of what makes this hard: a tiled window has a 10px strip of
    # wallpaper beside it and nothing more, so a shadow that has not finished
    # falling off within 10px never resolves -- it just leaves the gap a flat
    # darker colour. Wide and soft (32px at 0.9, then 20px at 0.5) both failed
    # exactly that way: what they looked like was the gaps having been
    # recoloured, not the windows having been lifted off anything.
    #
    # So this is a contact shadow rather than a cast one: short range, high
    # alpha, and render_power 4 -- a *faster* falloff than hyprland's default 3,
    # which packs the darkness against the window edge and lets the coral climb
    # back to full strength before the strip runs out. Telling these apart needs
    # a screenshot of that 12px strip at 4x; at 1x every one of them just looks
    # like "a bit dark".
    #
    # It is also the more honest shadow for the shape language. A sticker is
    # pressed flat onto the page: it has a hairline of dark where its edge meets
    # the paper, not the long soft pool of something floating above it.
    #
    # 3px down and nothing sideways -- enough to say which way is up, not enough
    # to imply a light source somewhere off-screen.
    #
    # base00 navy, and specifically not black. Black over this wallpaper
    # desaturates it: the coral goes grey and dirty under the shadow, which reads
    # as a rendering fault rather than as shade. The navy darkens the coral and
    # leaves it coral.
    shadow = {
      enable = true;
      x = 0;
      y = 3;
      range = 16;
      power = 4;
      color = "base00";
      a = 0.8;
    };

    # This wallpaper is far louder than cybergirl's -- hot pink across the whole
    # field -- so surfaces sit near-opaque or their text has to fight it.
    # `terminal` reaches kitty and `active` reaches GTK apps via stylix; see the
    # opacity block in themes/default.nix.
    opacity = {
      terminal = 0.95;
      active = 1.0;
      inactive = 0.94;
      panel = 1.0;
      bar = 1.0;
    };

    blur = {
      enable = true;
      size = 8;
      passes = 3;
      noise = 1.0e-2;
      xray = false;
    };

    gaps = {
      inner = 5;
      outer = 10;
    };

    accent = {
      primary = "base08"; # coral-rose; the edge and the active colour
      secondary = "base0F"; # hot pink; the far end of every gradient
      info = "base0C"; # lighter cyan, distinct from base0D
      ok = "base0B"; # turquoise
      warn = "base0A"; # yellow -- a rare highlight, no longer the edge
      err = "base09"; # vermilion
    };
  };
}
