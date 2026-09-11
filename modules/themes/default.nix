{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  registry = import ./registry.nix { inherit pkgs; };
  cfg = config.alienix.theme;
in
{
  options.alienix.theme = {
    name = mkOption {
      type = types.enum (attrNames registry);
      default = "cybergirl";
      description = "The active theme. Everything visual is derived from this.";
    };

    active = mkOption {
      type = types.attrs;
      readOnly = true;
      internal = true;
      description = "The resolved theme attrset. Read this; never set it.";
    };
  };

  config = {
    alienix.theme.active = registry.${cfg.name} // {
      # Style functions are called with the theme's own data plus the colour
      # helpers, so a presentation file never has to thread arguments itself.
      c = import ./lib.nix { inherit lib; } registry.${cfg.name};
    };

    stylix = {
      enable = true;
      polarity = cfg.active.meta.polarity;
      base16Scheme = cfg.active.palette;

      fonts = {
        monospace = cfg.active.fonts.monospace;
        sansSerif = cfg.active.fonts.ui;
        sizes = cfg.active.fonts.sizes;
      };
    }
    // optionalAttrs config.nixpkgs.hostPlatform.isLinux {
      image = cfg.active.wallpaper;

      # The theme already has an opacity language -- hyprland reads the same
      # tokens for its window opacities. Handing them to stylix as well is what
      # makes a terminal actually honour it; without this kitty sat fully opaque
      # while hyprland was told to draw it at 0.75.
      opacity = {
        terminal = cfg.active.tokens.opacity.terminal;
        desktop = cfg.active.tokens.opacity.bar;
        popups = cfg.active.tokens.opacity.panel;
        applications = cfg.active.tokens.opacity.active;
      };

      # stylix does have an icon target -- it feeds the qt and gnome targets and
      # is what puts a real icon theme behind file dialogs and the tray. The
      # theme picks the package; both entries are the same name because the
      # themes here are all dark.
      icons = {
        enable = true;
        package = cfg.active.icons.package;
        dark = cfg.active.icons.name;
        light = cfg.active.icons.name;
      };
    };
  };
}
