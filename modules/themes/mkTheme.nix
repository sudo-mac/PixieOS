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
        desktop = 12;
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
      greeter = "regreet";
      power = "wlogout";
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
      wlogout = import ./style/wlogout.nix;
      regreet = import ./style/regreet.nix;
      claude = import ./style/claude.nix;
    };
  };

  # Structure, as opposed to colour. A theme says where the bar sits and whether
  # it breaks into islands, whether the launcher is a list or a grid, and which
  # tiling engine and motion feel it wants -- so two themes can differ in shape
  # and not only in palette. Before this group existed a theme could vary the
  # numbers fed into the style files but never the layout they produced.
  #
  # The values here are cybergirl's structure, which is what every theme was
  # getting implicitly.
  defaultLayout = {
    bar = {
      position = "top"; # "top" | "bottom"
      height = 64;
      islands = false; # false = one continuous bar, true = 3 detached groups
      margin = 0;
    };

    launcher = {
      mode = "list"; # "list" | "grid"
      columns = 1;
      lines = 8;
      width = 720;
      iconSize = 20;
    };

    window = {
      engine = "dwindle"; # "dwindle" | "master"
      motion = "smooth"; # "smooth" | "snap" | "spray" -- see style/hyprland.nix
    };

    notifier = {
      position = "top-right";
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

  # `tokens` is the one group a theme always states in full, so it is passed
  # through untouched -- except for `layout`, which merges two levels deep so a
  # theme can move the bar to the bottom without restating the launcher and the
  # window manager as well.
  tokens = theme.tokens // {
    layout =
      let
        given = theme.tokens.layout or { };
      in
      builtins.mapAttrs (group: defaults': defaults' // (given.${group} or { })) defaultLayout;
  };
}
