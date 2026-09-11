{ pkgs, lib, config, ... }:
with lib;
let
  theme = config.alienix.theme.active;
in
{
  # The palette, wallpaper and fonts come from the active theme
  # (modules/themes). This file only decides which stylix targets are allowed
  # to act on them.
  home-manager = optionalAttrs config.nixpkgs.hostPlatform.isLinux {
    users.dex.config = {
      home.pointerCursor.enable = true;
      stylix = {
        cursor = {
          inherit (theme.cursor) package name size;
        };

        targets = {
          # GTK and Qt build straight from base16Scheme, which the theme already
          # supplies, so they follow the active theme without needing a style
          # file of their own. They were off, which left pavucontrol, the
          # network editor, nm-applet, dolphin, ark and every file dialog in
          # stock light Adwaita on a dark desktop.
          gtk.enable = true;
          qt.enable = true;
          # (kde.decorations is a string naming a decoration library, not a flag --
          # the old `kde.decorations.enable = false` here was a no-op.)
          kde.enable = true;
          rofi.enable = true;

          # Hyprland's border colours are set by the generated appearance.lua,
          # from the theme's border tokens. Two sources for one setting only
          # ever fight -- previously stylix wrote a flat rgb(3aa6ff) while the
          # Lua wrote a gradient, and load order decided the winner.
          hyprland.enable = false;
        };
      };
    };
  };
}
