{ config, lib, pkgs, ... }:
with lib; {
  options = {
    plasmasys.enable = mkEnableOption "Enable and Configure Plasma6";
  };

  config = mkIf config.plasmasys.enable {
    # System-level settings
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.enable = true;
    services.xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };
}
