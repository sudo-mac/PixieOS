{ config, lib, pkgs, ... }:
with lib; {
  options = {
    alienix.system.hyprland.enable =
      mkEnableOption "Enable and configure Hyprland for the system.";
  };

  config = mkIf config.alienix.system.hyprland.enable {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    hardware.graphics.enable = true;

    xdg.portal.enable = true;
  };
}
