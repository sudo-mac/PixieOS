{ config, lib, ... }:
with lib; {
  options = { alienix.system.asus.enable = mkEnableOption "Enable ASUS plugins"; };

  config = mkIf config.alienix.system.asus.enable {
    services = {
      asusd = {
        enable = true;
        enableUserService = true;
      };

      supergfxd.enable = true;

      # environment.systemPackages = [ pkgs.asusctl ];
    };
  };
}
