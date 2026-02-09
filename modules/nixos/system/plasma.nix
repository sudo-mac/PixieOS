{ config, lib, pkgs, ... }:
with lib; {
  options = {
    plasmasys.enable = mkEnableOption "Enable and Configure Plasma6";
  };

  config = mkIf config.plasmasys.enable {
    # System-level settings
    services.desktopManager.plasma6.enable = true;
    services.xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Exclude unneccessary Plasma packages
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      oxygen
      kate
    ];
  };
}
