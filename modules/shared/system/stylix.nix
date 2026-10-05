{ pkgs, lib, config, ... }:
with lib;
let
  theme = config.alienix.theme.active;
in
{
  # The kde target below points every KDE app at a colour scheme generated from
  # the palette (UiSettings.ColorScheme in kdeglobals), and installs the
  # .colors file into the user profile. But the per-user profile only links the
  # subdirs named here, and share/color-schemes is only a default under Plasma.
  # Without it dolphin, ark and friends could not find the scheme and fell back
  # to Breeze Light's built-in colours -- near-black text drawn on the dark
  # Kvantum background.
  environment = {
    pathsToLink = mkIf config.nixpkgs.hostPlatform.isLinux [ "/share/color-schemes" ];
  }
  // optionalAttrs config.nixpkgs.hostPlatform.isLinux {
    # That UiSettings.ColorScheme line lives in a kdeglobals stylix ships as its
    # own store path, added to XDG_CONFIG_DIRS through home-manager's session
    # variables. Those only reach login shells and systemd's environment.d --
    # the plain Hyprland session greetd starts reads neither, so anything
    # launched from a keybind or rofi never saw the file and the scheme above
    # was never selected. PAM's session environment does reach it.
    sessionVariables.XDG_CONFIG_DIRS = mkBefore config.home-manager.users.dex.xdg.systemDirs.config;
  };

  # The palette, wallpaper and fonts come from the active theme
  # (modules/themes). This file only decides which stylix targets are allowed
  # to act on them.
  home-manager = {
    # rofi is owned end to end by the theme: launcher/rofi.nix forces
    # programs.rofi.theme to the theme name and writes the .rasi, whose `*` block
    # sets the font. That left stylix's rofi target contributing nothing but a
    # definition of the pre-rename `programs.rofi.font`, which warned on every
    # evaluation. It goes through sharedModules because it has to reach the
    # darwin profile too, which never configures rofi at all but still got the
    # warning.
    sharedModules = [ { stylix.targets.rofi.enable = false; } ];
  }
  // optionalAttrs config.nixpkgs.hostPlatform.isLinux {
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
