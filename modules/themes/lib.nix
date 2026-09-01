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
  # hard offset cast shadow (kimberly's sticker look), or nothing at all. One
  # helper so component styles never have to know which the theme picked.
  depthCss =
    slot:
    if tokens.glow.enable then
      lib.concatMapStringsSep ",\n    " (
        l: "0 0 ${toString l.r}px alpha(@${slot}, ${toString l.a})"
      ) tokens.glow.layers
    else if tokens.shadow.enable then
      "${toString tokens.shadow.x}px ${toString tokens.shadow.y}px 0 alpha(@${tokens.shadow.color}, ${toString tokens.shadow.a})"
    else
      "none";
in
{
  inherit bare hex withAlpha hexA slotOf depthCss;

  # Kept as an alias so glow-using call sites still read naturally.
  glowCss = depthCss;

  # Role-flavoured shorthands
  accentHex = role: hex (slotOf role);
  accentBare = role: bare (slotOf role);

  # GTK-CSS named colour, as injected by stylix's waybar target
  named = slot: "@${slot}";
}
