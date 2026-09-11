# Fonts, cursor, icons, component slots and the presentation layer all come
# from mkTheme's defaults -- see modules/themes/mkTheme.nix.
{ pkgs }:
{
  meta = {
    name = "cybergirl";
    description = "Cyberpunk anime girl -- deep navy, hot pink, neon cyan glow.";
    polarity = "dark";
  };

  # The base16 palette. Feeds stylix, which fans it out to every target it
  # knows about (kitty, btop, nvf, librewolf, vscodium, waybar's @baseXX ...).
  palette = {
    base00 = "071726";
    base01 = "0e2438";
    base02 = "163854";
    base03 = "2a5573";
    base04 = "6fa3c9";
    base05 = "b8dcff";
    base06 = "e6f4ff";
    base07 = "f2fbff";

    base08 = "ff4f9a";
    base09 = "ff8cc6";
    base0A = "ffd166";
    base0B = "6fffd2";
    base0C = "4fdfff";
    base0D = "3aa6ff";
    base0E = "b388ff";
    base0F = "ff6fd8";
  };

  wallpaper = ./wallpapers/cybergirl.jpg;

  # The shared style vocabulary. Every component reads these instead of
  # hardcoding literals, so the whole desktop reshapes from one place.
  tokens = {

    # A single continuous bar across the top, a list launcher, and the long
    # eased motion the blur is built around. These are also mkTheme's defaults
    # -- stated here rather than inherited so the two themes read as peers.
    layout = {
      bar = {
        position = "top";
        height = 64;
        islands = false;
        margin = 0;
      };

      launcher = {
        mode = "list";
        columns = 1;
        lines = 8;
        width = 720;
        iconSize = 20;
      };

      window = {
        engine = "dwindle";
        motion = "smooth";
      };

      notifier = {
        position = "top-right";
      };
    };

    radius = {
      pill = 999;
      window = 10;
      card = 18;
      input = 20;
      shape = 26;
    };

    border = {
      width = 3;
      angle = 45;
      from = "base0C";
      to = "base0E";
      inactive = "base02";
    };

    # Hex-alpha bytes, matching what hyprland and hyprlock expect.
    alpha = {
      full = 238; # ee -- gradient borders, input outline
      strong = 204; # cc -- inner field, drop shadows
      medium = 170; # aa -- inactive window border
      card = 102; # 66 -- glass card fill
      hairline = 85; # 55 -- glass card border
    };

    glow = {
      enable = true;
      color = "base0D";
      layers = [
        { r = 4; a = 0.75; }
        { r = 8; a = 0.35; }
      ];
    };

    # This theme uses neon glow for depth, not a cast shadow. The rest of the
    # group is stated anyway so the token shape is the same in every theme and
    # flipping `enable` is the only edit needed to try one.
    shadow = {
      enable = false;
      x = 0;
      y = 0;
      range = 0;
      power = 3;
      color = "base00";
      a = 0.0;
    };

    opacity = {
      terminal = 0.75;
      active = 0.75;
      inactive = 0.8;
      panel = 0.95;
      bar = 0.85;
    };

    blur = {
      enable = true;
      size = 14;
      passes = 4;
      noise = 1.0e-2;
      xray = true;
    };

    gaps = {
      inner = 5;
      outer = 15;
    };

    # Semantic accent roles. Components reference these rather than raw base
    # slots, so a theme can remap "primary" without every consumer knowing.
    accent = {
      primary = "base08";
      secondary = "base0F";
      info = "base0C";
      ok = "base0B";
      warn = "base0A";
      err = "base08";
    };
  };
}
