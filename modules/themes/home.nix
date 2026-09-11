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

  # Fonts, the cursor and the icon theme are all installed by stylix, which the
  # theme feeds -- see the `icons` block in ./default.nix. Nothing left to
  # install here.
}
