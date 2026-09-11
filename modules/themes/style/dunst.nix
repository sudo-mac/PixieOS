# Presentation for notifications: the colour/shape half of dunst's settings,
# plus where on screen they belong. Behaviour stays in the component module.
{
  tokens,
  fonts,
  icons,
  c,
  ...
}:
{
  global = {
    highlight = c.hex c.edge;

    corner_radius = tokens.radius.card;
    frame_width = 2;
    frame_color = c.hex c.edge;
    separator_color = "frame";
    separator_height = 2;

    # Without this the stack is one slab: dunst butts the popups edge to edge,
    # so three notifications of three urgencies drew three differently-coloured
    # frames sharing borders, and the corner radius only showed on the outermost
    # two corners. A gap makes each one its own card -- which is the shape every
    # other surface in the theme is already using -- and it is the desktop's own
    # inner gap so the rhythm matches.
    gap_size = tokens.gaps.inner;

    font = "${fonts.ui.name} ${toString fonts.sizes.popups}";
    transparency = 8;

    # Notifications belong on the same edge as the bar, so they never open
    # underneath it. dunst names the corner; the bar's own margin keeps them
    # clear of it.
    origin = tokens.layout.notifier.position;
    offset = "${toString (tokens.layout.bar.margin + 12)}x${
      toString (tokens.layout.bar.height + tokens.layout.bar.margin + 12)
    }";

    # Papirus (or whatever the theme picked) rather than the hicolor fallback
    # -- stylix's dunst target would have set this, but the theme owns dunst.
    icon_theme = icons.name;
    enable_recursive_icon_lookup = true;
  };

  urgency_low = {
    background = c.hex "base00";
    foreground = c.hex "base04";
    frame_color = c.hex tokens.border.inactive;
  };

  urgency_normal = {
    background = c.hex "base00";
    foreground = c.hex "base05";
    frame_color = c.hex c.edge;
  };

  urgency_critical = {
    background = c.hex "base00";
    foreground = c.hex "base07";
    frame_color = c.accentHex "err";
  };
}
