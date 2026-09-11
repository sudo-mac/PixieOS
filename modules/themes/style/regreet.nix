# Presentation for the greeter. regreet is a GTK app, so this is GTK-CSS over
# the same wallpaper the lock screen and desktop use -- the login screen is the
# first thing the theme should say, and it was a bare TTY.
{
  tokens,
  fonts,
  wallpaper,
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
  # Contain, not Cover. regreet runs under `cage`, and with a second output
  # attached the surface it draws into can be wider than any one monitor -- Cover
  # then upscales a 1920x1080 image to span it and crops the middle out, which is
  # why the login screen looked zoomed in. On a single 16:9 output the two fits
  # are identical, so this costs nothing there.
  background = {
    path = toString wallpaper;
    fit = "Contain";
  };

  css = ''
    ${c.defineColors}

    * {
      font-family: "${fonts.ui.name}";
      font-size: ${toString fonts.sizes.desktop}pt;
    }

    /* Whatever Contain leaves uncovered is the theme's ground, not adw-gtk3's. */
    window {
      background-color: ${c.hex "base00"};
    }

    /* The login card, floating over the wallpaper in the theme's own shape. */
    window > box {
      background-color: ${c.cssA "base00" alpha.card};
      border: ${toString border.width}px solid ${c.hex c.edge};
      border-radius: ${toString radius.card}px;
      padding: 28px;

      box-shadow: ${c.depthCss c.edge};
    }

    label {
      color: ${c.hex "base05"};
    }

    entry,
    button,
    combobox button {
      color: ${c.hex "base06"};
      background-color: ${c.cssA "base01" alpha.strong};

      border: ${toString border.width}px solid ${c.hex tokens.border.inactive};
      border-radius: ${toString radius.input}px;
      padding: 8px 12px;
    }

    entry:focus {
      border-color: ${c.accentHex "info"};
    }

    button:hover {
      color: ${c.hex "base00"};
      background-color: ${c.accentHex "primary"};
      border-color: ${c.accentHex "primary"};
    }

    entry:disabled,
    label:disabled {
      color: ${c.hex "base03"};
    }
  '';
}
