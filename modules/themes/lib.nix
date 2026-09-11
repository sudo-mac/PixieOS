# Helpers handed to every theme's style/* function, so presentation files can
# talk about colours by base16 slot or by semantic accent role instead of
# repeating hex literals.
{ lib }:
theme:
let
  inherit (theme) palette tokens;

  # "base08" -> "ff4f9a"
  bare = slot: palette.${slot};

  # "base08" -> "#ff4f9a"
  hex = slot: "#" + bare slot;

  # "base08" 0.5 -> "ff4f9aee"-style hex-alpha, for hyprland/hyprlock rgba()
  withAlpha =
    slot: a:
    let
      byte = builtins.floor (a * 255.0 + 0.5);
      digits = "0123456789abcdef";
      hi = builtins.substring (byte / 16) 1 digits;
      lo = builtins.substring (lib.mod byte 16) 1 digits;
    in
    bare slot + hi + lo;

  # "base08" 238 -> "ff4f9aee". Byte-valued because hyprland/hyprlock express
  # alpha as a hex pair, and rounding a float there shifts the colour.
  hexA =
    slot: byte:
    let
      digits = "0123456789abcdef";
      hi = builtins.substring (byte / 16) 1 digits;
      lo = builtins.substring (lib.mod byte 16) 1 digits;
    in
    bare slot + hi + lo;

  # Semantic role -> slot, e.g. "primary" -> "base08"
  slotOf = role: tokens.accent.${role};

  # How a theme expresses depth as a CSS box-shadow: a neon glow (cybergirl), a
  # cast shadow the surface sits above (kimberly), or nothing at all. One helper
  # so component styles never have to know which the theme picked.
  #
  # The cast-shadow branch used to hardcode a 0px blur, which is the whole of why
  # it was written off as unusable: GTK renders a zero-blur box-shadow on a
  # rounded box as a hard duplicate of the box peeking out on two sides, which is
  # a smudge and not a shadow. It takes `tokens.shadow.range` as the blur radius
  # now -- the same number hyprland reads as its shadow range -- so a surface
  # casts the same shadow whichever renderer is drawing it.
  depthCss =
    slot:
    if tokens.glow.enable then
      lib.concatMapStringsSep ",\n    " (
        l: "0 0 ${toString l.r}px alpha(@${slot}, ${toString l.a})"
      ) tokens.glow.layers
    else if tokens.shadow.enable then
      "${toString tokens.shadow.x}px ${toString tokens.shadow.y}px ${toString tokens.shadow.range}px alpha(@${tokens.shadow.color}, ${toString tokens.shadow.a})"
    else
      "none";

  # The colour a theme draws its edges in. A glowing theme outlines in its glow
  # colour; a theme that uses a flat keyline outlines in the keyline itself.
  # Reading tokens.glow.color directly is wrong for the second kind -- kimberly
  # kept picking up cybergirl's neon that way despite glow.enable = false.
  edge = if tokens.glow.enable then tokens.glow.color else tokens.border.from;

  # Byte-valued alpha (what the tokens are expressed in, because hyprland wants
  # a hex pair) as the decimal fraction GTK-CSS wants.
  frac =
    byte:
    let
      h = builtins.floor (byte * 100.0 / 255.0 + 0.5);
    in
    if h >= 100 then
      "1.0"
    else
      "0.${if h < 10 then "0${toString h}" else toString h}";

  # The @define-color preamble a GTK-CSS surface needs before it can name a
  # palette slot. stylix injects this for waybar, but wlogout and regreet get
  # nothing from it, so they emit it themselves -- otherwise every @baseXX in
  # their stylesheet (including the one depthCss produces) silently does nothing.
  defineColors = lib.concatMapStringsSep "\n" (slot: "@define-color ${slot} ${hex slot};") (
    builtins.attrNames palette
  );
in
{
  inherit
    bare
    hex
    withAlpha
    hexA
    slotOf
    depthCss
    defineColors
    edge
    ;

  # Kept as an alias so glow-using call sites still read naturally.
  glowCss = depthCss;

  # Role-flavoured shorthands
  accentHex = role: hex (slotOf role);
  accentBare = role: bare (slotOf role);

  # GTK-CSS colour with alpha, e.g. cssA "base00" 225 -> "alpha(@base00, 0.88)"
  cssA = slot: byte: "alpha(@${slot}, ${frac byte})";

  # GTK-CSS named colour, as injected by stylix's waybar target
  named = slot: "@${slot}";
}
