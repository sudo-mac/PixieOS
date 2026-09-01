# Fills in everything a theme doesn't need to state for itself.
#
# Only the things that genuinely define a theme are required -- meta, palette,
# wallpaper and tokens. Fonts, cursor, icons, the component slots and the whole
# presentation layer default to the shared set, so a new theme is a palette, an
# image and a shape language rather than a copy of the last one.
{ pkgs }:
let
  defaults = {
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      # The proportional cut. Used for UI chrome (bar, launcher, notifications)
      # where kerning matters more than fixed-width alignment.
      ui = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Propo";
      };

      sizes = {
        terminal = 14;
        desktop = 10;
        popups = 10;
        applications = 12;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    icons = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };

    components = {
      bar = "waybar";
      launcher = "rofi";
      notifier = "dunst";
      lock = "hyprlock";
      wallpaper = "awww";
    };

    # The shared, token-driven presentation. A theme overrides an entry here
    # only when tokens genuinely can't express what it wants.
    style = {
      waybar = import ./style/waybar.nix;
      rofi = import ./style/rofi.nix;
      dunst = import ./style/dunst.nix;
      hyprlock = import ./style/hyprlock.nix;
      hyprland = import ./style/hyprland.nix;
      claude = import ./style/claude.nix;
    };
  };
in
theme:
# One level of merging per top-level key, so a theme can override a single
# font or a single style file without restating the rest of the group.
defaults
// theme
// {
  fonts = defaults.fonts // (theme.fonts or { });
  cursor = defaults.cursor // (theme.cursor or { });
  icons = defaults.icons // (theme.icons or { });
  components = defaults.components // (theme.components or { });
  style = defaults.style // (theme.style or { });
}
