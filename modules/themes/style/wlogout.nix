# Presentation for the power menu: a grid of buttons over the dimmed desktop.
# Shape comes from the same tokens as everything else, so it reads as a glowing
# card wall under cybergirl and a sheet of stickers under kimberly.
#
# The per-button icons are appended by the component module, which is where
# `pkgs` -- and therefore wlogout's own icon set -- is in scope. It tints them
# with the two colours exported at the bottom of this file, so the glyph tracks
# the label instead of staying stock lavender on a coloured button.
{
  tokens,
  fonts,
  c,
  ...
}:
let
  inherit (tokens)
    radius
    border
    alpha
    ;
in
{
  css = ''
    ${c.defineColors}

    * {
      box-shadow: none;
      font-family: "${fonts.ui.name}";
      font-size: ${toString fonts.sizes.desktop}pt;
      font-weight: 600;
    }

    /* Only the window suppresses a background image. Blanketing `*` with it --
       which is what this file used to do -- also blanked the button icons,
       since wlogout draws those as CSS background-images and home-manager
       replaces its stock stylesheet wholesale. */
    window {
      background-image: none;
      background-color: ${c.cssA "base00" alpha.strong};

      /* Inset, so six buttons read as a panel rather than tiling the screen.
         Absolute units on purpose: GTK-CSS has no percentage length, and the
         `8% 14%` this used to say was not a value GTK could parse -- one bad
         declaration made it abandon the rest of the file, which is why the
         buttons below had no border, no margin and no icon. */
      padding: 90px 220px;
    }

    button {
      color: ${c.hex "base05"};
      background-color: ${c.cssA "base01" alpha.card};

      border: ${toString border.width}px solid ${c.hex c.edge};
      border-radius: ${toString radius.card}px;

      margin: 10px;
      min-height: 120px;

      background-repeat: no-repeat;
      background-position: center 34%;
      background-size: 28%;

      box-shadow: ${c.depthCss c.edge};

      transition: all 200ms ease-in-out;
    }

    /* Keyboard focus and pointer hover are the same state visually -- the menu
       is six equal choices and only ever has one of them selected. */
    button:focus,
    button:active,
    button:hover {
      color: ${c.hex "base00"};
      background-color: ${c.accentHex "primary"};
      border-color: ${c.accentHex "primary"};
    }
  '';

  # Stock wlogout ships one pale-lavender PNG per action. Left alone it reads as
  # the one un-themed thing on the screen, and it vanishes into the fill once a
  # button lights up in the accent. The component module re-tints the set twice,
  # once per state, using these.
  iconColor = c.hex "base05";
  iconColorActive = c.hex "base00";
}
