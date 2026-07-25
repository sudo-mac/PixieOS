{ config, lib, ... }:
let
  colors = config.lib.stylix.colors;
in
{
  stylix.targets.swaylock.image.enable = false;

  programs.swaylock = {
    enable = true;
    settings = {
      color = lib.mkForce "${colors.base00-hex}aa";

      font = "JetBrainsMono Nerd Font Propo";
      font-size = 24;
      indicator-radius = 100;
      indicator-thickness = 10;
    };
  };
}
