{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  theme = config.alienix.theme.active;
  style = theme.style.wlogout theme;

  buttons = [
    {
      label = "lock";
      # Not `loginctl lock-session`: that only emits logind's Lock signal, and
      # nothing in this configuration listens for it (there is no hypridle or
      # swayidle), so the button was silently doing nothing.
      action = "hyprlock";
      text = "Lock";
      keybind = "l";
    }
    {
      label = "hibernate";
      action = "systemctl hibernate";
      text = "Hibernate";
      keybind = "h";
    }
    {
      label = "logout";
      action = "loginctl terminate-user $USER";
      text = "Log out";
      keybind = "e";
    }
    {
      label = "shutdown";
      action = "systemctl poweroff";
      text = "Shutdown";
      keybind = "s";
    }
    {
      label = "suspend";
      action = "systemctl suspend";
      text = "Suspend";
      keybind = "u";
    }
    {
      label = "reboot";
      action = "systemctl reboot";
      text = "Reboot";
      keybind = "r";
    }
  ];

  # wlogout ships one PNG per label. The theme cannot name them itself -- style
  # functions are handed the theme, not `pkgs` -- so the set is resolved here.
  #
  # The stock glyphs are a fixed pale lavender, which is the one colour on the
  # screen no theme picked and which disappears the moment a button fills with
  # the accent. `-alpha shape` repaints the coverage mask in a flat colour and
  # keeps the antialiased edge, so the same six icons come out in whatever the
  # theme asked for -- once for rest, once for the focused/hovered state.
  tintIcons =
    name: colour:
    pkgs.runCommand "wlogout-icons-${theme.meta.name}-${name}"
      {
        nativeBuildInputs = [ pkgs.imagemagick ];
      }
      ''
        mkdir -p "$out"
        for icon in ${pkgs.wlogout}/share/wlogout/icons/*.png; do
          magick "$icon" -alpha extract \
            -background '${colour}' -alpha shape \
            "$out/$(basename "$icon")"
        done
      '';

  restIcons = tintIcons "rest" style.iconColor;
  activeIcons = tintIcons "active" style.iconColorActive;

  # Appended to the stylesheet the theme built rather than interpolated into it,
  # for the same reason: only this file can see the store paths.
  iconCss = concatMapStringsSep "\n" (b: ''
    #${b.label} {
      background-image: image(url("${restIcons}/${b.label}.png"));
    }

    #${b.label}:focus,
    #${b.label}:active,
    #${b.label}:hover {
      background-image: image(url("${activeIcons}/${b.label}.png"));
    }
  '') buttons;
in
{
  # wlogout is what the bar's power button and SUPER+ESCAPE open (see
  # bar/waybar/default.nix and keybindings.lua). It had no styling of any kind --
  # stylix has no wlogout target either -- so it was the one full-screen surface
  # still in stock black and white.
  config = mkIf (theme.components.power == "wlogout") {
    programs.wlogout = {
      enable = true;

      layout = buttons;

      style = style.css + "\n" + iconCss;
    };
  };
}
