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
    };
  };
}
