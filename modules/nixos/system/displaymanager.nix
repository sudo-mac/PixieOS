{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    alienix.system.displaymanager.enable = mkEnableOption "Enable and Configure Display Manager";
  };

  config = mkIf config.alienix.system.displaymanager.enable {
    services.displayManager.sddm.wayland.enable = true;
    services.displayManager.sddm.enable = true;
  };
}
