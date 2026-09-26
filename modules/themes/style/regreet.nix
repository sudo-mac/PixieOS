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
  # Cover. The greeter gets one output to itself (alienix.system.greeter.output,
  # see nixos/system/greeter/regreet.nix), so the surface regreet draws into is
  # a single monitor and Cover is what fills it without letterboxing.
  #
  # It was Contain, for the compositor this replaced: cage glues every connected
  # output into one surface, so with a second monitor attached Cover was
  # upscaling a 1920x1080 image to span 3280 pixels and cropping the middle out.
  # Contain stopped the zoom but not the real problem, which was that the image
  # was centred in a canvas whose centre is the seam between the two screens.
  # Confining the greeter is what actually fixed that, and it also takes away
  # the reason Contain was here.
  background = {
    path = toString wallpaper;
    fit = "Cover";
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
