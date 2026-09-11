# Kimberly's bar, which is not a bar: three stickers slapped along the top edge
# of the wallpaper. The shared style/waybar.nix draws one continuous strip with a
# gradient and rounded glowing pills -- the opposite of this theme's language --
# so it is replaced wholesale rather than bent with conditionals.
#
# The pieces that aren't shape (the cpu ramp, the calendar spans) are identical
# to the shared file's and are re-exported from it, so a palette change still
# only has to happen in one place.
{
  tokens,
  fonts,
  c,
  ...
}@args:
let
  inherit (tokens)
    radius
    border
    opacity
    layout
    shadow
    ;

  shared = import ../../style/waybar.nix args;

  keyline = c.accentHex "primary"; # coral-rose
  keylineHi = c.accentHex "secondary"; # hot pink

  # Breathing room above and below each island, so they read as three objects
  # lying on the wallpaper rather than a strip that has been cut into thirds.
  lift = 4;

  # The corner the islands are cut to. Rounder than `radius.card`, and stated
  # here rather than by raising that token, because the token is also the corner
  # on the tooltip, the wlogout tiles and the hyprlock card -- all of them large
  # surfaces, where 12px reads as generous. On a 44px-tall island it reads as a
  # rectangle with the corners filed off. 18 is most of the way to the 22 that
  # would make it a capsule, which is the point: a sticker is die-cut round, not
  # rolled into a pill.
  corner = radius.card + 6;

  # The island's contact shadow: the same one the windows sit on, in the scale a
  # 40px-tall panel can wear.
  #
  # `shadow.range` is a hyprland range and this is a CSS blur radius; the two are
  # not the same unit and do not convert, so the colour comes from the theme and
  # the geometry is stated here. Every pixel the shadow needs is also a pixel the
  # layer surface reserves off the top of the workspace, which bounds it far more
  # tightly than anything bounds the window shadow.
  #
  # What this replaces is a hard 2px "die-cut" band of navy drawn outside the
  # keyline, which existed only because a zero-blur box-shadow was the one thing
  # GTK would render cleanly. A blurred one renders just as cleanly, and does the
  # job the band was standing in for -- keeping the island legible over a
  # wallpaper that has a bright version of nearly every hue somewhere in it --
  # without also adding a second visible edge to a surface that has one already.
  #
  # Bolder and tighter than it was, which is one move and not two. 10px of blur
  # at 0.8 spent its darkness over a 9px falloff, so the strongest pixel in it
  # was still fairly pale and the whole thing occupied 72px of screen to say so:
  # volume standing in for weight. 6px at 0.95 puts the same navy right up
  # against the keyline where it actually reads, and hands 8px of the strip back.
  #
  # The alpha is the one number here that does not come from `shadow.a` (0.8).
  # The window shadow is read across a 10px gap of wallpaper and this one is read
  # at the island's own edge, over 6px rather than 16 -- the shorter the falloff,
  # the darker the near end has to be to land as the same shadow.
  cast = {
    y = 2;
    blur = 6;
    a = 0.95;
  };

  # How far the shadow actually reaches past the island, and the whole of why the
  # first version of it read as a rectangle with the corners cut off rather than
  # as a shadow.
  #
  # The CSS model says a blur of B spreads B/2 outside the box, and reserving B/2
  # here is precisely what clipped it. GTK does not blur to the CSS extent: it
  # reads the blur radius as two standard deviations (sigma = B/2) and truncates
  # its gaussian at 3*sqrt(2*pi)/4 sigma -- about 1.88 sigma, or 0.94*B. A 6px
  # blur therefore paints six pixels past the border box, not three. The missing
  # half was not being drawn faintly, it was being cut off: the
  # margins below are the whole of the widget's allocation and GTK clips a
  # widget's shadow to it, so the falloff ended in a straight line on all four
  # sides -- and a straight line is what "squared off" is. The corners lost the
  # most, because a corner is where the shadow has furthest to travel.
  #
  # So the extent is the blur radius itself: 0.94 rounded up, which costs one
  # pixel of margin per side and spares this file a float. Everything below sets
  # its margins from these, so the layer surface is exactly big enough to hold
  # the shadow and not a pixel bigger.
  reach = {
    below = cast.blur + cast.y;
    above = cast.blur - cast.y;
    side = cast.blur;
  };

  strip = layout.bar.height + (2 * border.width) + (2 * lift) + reach.above + reach.below;

  # A sticker: flat fill, a keyline, and the shadow it sits above.
  sticker = ''
    background: alpha(@base00, ${toString opacity.panel});
    border: ${toString border.width}px solid ${keyline};
    border-radius: ${toString corner}px;

    box-shadow: 0 ${toString cast.y}px ${toString cast.blur}px alpha(@${shadow.color}, ${toString cast.a});
  '';
in
shared
// {
  # The palette preamble is emitted here rather than leaned on from stylix's
  # waybar target: home-manager concatenates the two stylesheets in an order
  # nothing guarantees, and stylix's half is switched off anyway (see
  # bar/waybar/default.nix). Redefining a colour is legal; missing one is not.
  css = ''
    ${c.defineColors}

    * {
      border: none;

      font-size: ${toString fonts.sizes.desktop}pt;
      font-family: "${fonts.ui.name}";
      font-weight: 600;

      min-height: 0;
      margin: 0;
      padding: 0px;
    }

    /* The bar itself is a hole. Only the three groups below are painted, so
       the wallpaper shows through between and around them. */
    window#waybar {
      background: transparent;
      border: none;
      box-shadow: none;
      padding: 0;
      margin: 0;
      min-height: ${toString strip}px;
    }

    tooltip {
      background: @base00;
      border: ${toString border.width}px solid ${keyline};
      border-radius: ${toString radius.card}px;
    }

    tooltip label {
      color: @base05;
      padding: 4px;
    }

    .modules-left,
    .modules-center,
    .modules-right {
      ${sticker}
      min-height: ${toString layout.bar.height}px;
      padding: 0 6px;
      /* Asymmetric on purpose: the shadow falls downward, so the clearance it
         needs above the island is not the clearance it needs below. Spending
         the larger number on both sides would reserve screen the shadow never
         reaches into. */
      margin: ${toString (lift + reach.above)}px ${toString (8 + reach.side)}px ${toString (lift + reach.below)}px;
    }

    /* The outer two already sit `layout.bar.margin` in from the screen edge --
       waybar's own margin-left/right does that -- so they don't need a second
       inset on that side, only room for the shadow itself.

       No width floor here either. 300px was picked to match the widest the
       window title could get, which made the island a fixed slab that was
       mostly empty most of the time. It grows rightward off a left-anchored
       edge, so letting it hug shifts nothing else on the bar; hyprland/window's
       max-length is what bounds it now. */
    .modules-left {
      margin-left: ${toString reach.side}px;
    }

    /* No width floor: the point of an island is that it is the size of what
       is in it. The 180px floor left the clock sitting against the left edge
       of a box with 90px of empty navy after it. */
    .modules-center {
      min-width: 0;
    }

    .modules-right {
      margin-right: ${toString reach.side}px;
    }

    /* Inside a sticker the modules are bare text -- the panel is the shape, so
       giving each module its own box would nest one sticker inside another. */
    #clock,
    #cpu,
    #tray,
    #pulseaudio,
    #custom-power,
    #battery,
    #network,
    #mpris,
    #custom-media-popup,
    #window {
      background: transparent;
      border: none;
      box-shadow: none;

      color: @base05;
      padding: 0 9px;
      margin: 0;
      min-height: ${toString layout.bar.height}px;
    }

    /* The hero of the centre island, so it gets a size and a weight of its own
       rather than the bar-wide defaults. The digits take the near-white so they
       carry against the near-black fill; the meridiem is the small pink suffix
       set in the format string (see clockFormat in the shared style). */
    #clock {
      color: @base06;
      font-size: ${toString (fonts.sizes.desktop + 1)}pt;
      font-weight: 800;
      padding: 0 14px;
    }

    #cpu.warning {
      color: ${c.accentHex "warn"};
    }

    #cpu.critical {
      color: ${c.accentHex "err"};
    }

    /* A bare signal-strength glyph (see bar/waybar/network.nix), so it takes the
       neutral foreground and lets the three coloured status modules either side
       of it do the talking. */
    #network {
      color: @base05;
    }

    #pulseaudio {
      color: ${c.accentHex "info"};
    }

    #battery {
      color: ${c.accentHex "ok"};
    }

    #battery.warning {
      color: ${c.accentHex "warn"};
    }

    #battery.critical {
      color: ${c.accentHex "err"};
    }

    #mpris {
      color: ${c.accentHex "ok"};
    }

    #custom-power {
      color: ${c.accentHex "secondary"};
      padding-right: 10px;
    }

    #custom-media-popup {
      color: ${c.accentHex "ok"};
      padding-left: 0;
    }

    #window {
      color: alpha(@base05, 0.7);
      font-weight: 500;
    }

    #workspaces {
      background: transparent;
      border: none;
      box-shadow: none;
      padding: 0 2px;
    }

    /* Spray-tag numbers. The six rules below are a ladder, weakest first, and
       the order and the class-count are load-bearing -- GTK resolves ties by
       source order and everything else by specificity, so a two-class rule
       always beats a one-class rule regardless of where it sits.

       No transition on any of them: this theme cuts, it does not glide. The
       transparent border-bottom is deliberate: stylix's waybar target draws a
       3px one at a higher specificity, so declaring it here is what keeps it
       neutralised if that target is ever switched back on. */

    /* 1. Occupied, but not on any screen right now. A paint drip under the
          number says there is something in there. */
    #workspaces button {
      background: transparent;
      border: none;
      border-bottom: ${toString border.width}px solid alpha(${keyline}, 0.6);
      border-radius: ${toString radius.pill}px;

      color: @base06;
      padding: 0 10px;
      margin: 4px 2px;
      min-width: 26px;

      box-shadow: none;
    }

    /* 2. A slot that exists because persistent-workspaces asked for it and has
          nothing in it. Ghosted, so the occupied numbers carry the eye. */
    #workspaces button.empty {
      border-bottom-color: transparent;
      color: alpha(@base05, 0.34);
    }

    /* 3. On a screen -- either one. Outlined, because the fill is reserved for
          the screen this bar is actually attached to. */
    #workspaces button.visible {
      background: transparent;
      border-bottom-color: transparent;
      box-shadow: inset 0 0 0 ${toString border.width}px alpha(${keyline}, 0.8);
      color: @base07;
    }

    /* 4. Where the keyboard is. waybar computes .active from the *globally*
          focused workspace and then sets it on every bar, so on two monitors
          both bars used to fill the same chip -- the laptop bar insisted you
          were on a workspace that only ever appears on the external screen.
          Marked in yellow, not filled, for exactly that reason: on the bar that
          is not hosting it, this is all you get. */
    #workspaces button.active {
      background: transparent;
      border-bottom-color: transparent;
      box-shadow: inset 0 0 0 ${toString border.width}px ${keylineHi};
      color: ${keylineHi};
    }

    /* 5. What *this* bar's monitor is displaying. .hosting-monitor is the only
          class waybar scopes to the bar's own output, which makes it the one
          class that can answer "where am I" on a multi-monitor desktop. */
    #workspaces button.visible.hosting-monitor {
      background: linear-gradient(135deg, ${keyline}, ${keylineHi});
      border-bottom-color: transparent;
      box-shadow: none;
      color: @base00;
    }

    /* 6. This screen, and the keyboard too -- the full tag. The outer halo is
          the focus mark from rule 4 wrapped around the fill from rule 5. */
    #workspaces button.active.hosting-monitor {
      background: linear-gradient(135deg, ${keyline}, ${keylineHi});
      border-bottom-color: transparent;
      box-shadow: 0 0 0 ${toString border.width}px alpha(${keylineHi}, 0.55);
      color: @base00;
    }

    /* Urgent outranks the whole ladder, so it is spelled at the top and the
       bottom of it: the bare selector catches rules 1-4 by source order, and
       the three-class one outspecifies rules 5 and 6. */
    #workspaces button.urgent,
    #workspaces button.urgent.visible.hosting-monitor {
      background: ${c.accentHex "warn"};
      border-bottom-color: transparent;
      box-shadow: none;
      color: @base00;
    }

    /* Last, and deliberately outspecifying the ladder, so pointing at a chip
       always acknowledges the pointer. The filled states keep their fill and
       flip the gradient rather than taking the wash, which would paint over the
       one piece of information the chip is carrying. */
    #workspaces button:hover {
      background: alpha(${keylineHi}, 0.2);
      color: @base07;
    }

    #workspaces button.visible.hosting-monitor:hover,
    #workspaces button.active.hosting-monitor:hover {
      background: linear-gradient(135deg, ${keylineHi}, ${keyline});
      color: @base00;
    }
  '';
}
