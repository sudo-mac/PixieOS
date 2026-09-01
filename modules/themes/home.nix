{ osConfig, lib, pkgs, ... }:
with lib;
let
  theme = osConfig.alienix.theme.active;
in
{
  # The home tree is a separate module evaluation from the system tree, so the
  # resolved theme is inherited across the boundary via osConfig rather than
  # being declared (and kept in sync) twice.
  options.alienix.theme.active = mkOption {
    type = types.attrs;
    readOnly = true;
    internal = true;
    default = theme;
    description = "The resolved theme, inherited from the system configuration.";
  };

  # Fonts and the cursor are installed by stylix, which the theme feeds. The
  # icon theme has no stylix target, so install it here -- rofi has been asking
  # for Papirus by name without anything providing it. Linux only: icon themes
  # are a desktop concern and their packages don't build on darwin.
  config.home.packages = optionals pkgs.stdenv.hostPlatform.isLinux [ theme.icons.package ];
}
