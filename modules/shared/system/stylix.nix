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
          kde.enable = false;
          kde.decorations.enable = false;
          gtk.enable = false;
          qt.enable = false;
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
